require 'rexml/document'
require 'xmlrpc/client'

class Ping < ActiveRecord::Base
  belongs_to :article

  class Pinger
    attr_accessor :article
    attr_accessor :blog

    def send_pingback_or_trackback
      @response = Net::HTTP.get_response(URI.parse(ping.url))
      send_pingback or send_trackback
    rescue Timeout::Error
      Rails.logger.info 'Sending pingback or trackback timed out'
      return
    rescue => err
      Rails.logger.info "Sending pingback or trackback failed with error: #{err}"
    end

    def pingback_url
      if response['X-Pingback']
        response['X-Pingback']
      elsif response.body =~ /<link rel="pingback" href="([^"]+)" ?\/?>/
        Regexp.last_match[1]
      end
    end

    attr_reader :origin_url

    attr_reader :response

    attr_reader :ping

    def send_xml_rpc(*args)
      ping.send(:send_xml_rpc, *args)
    end

    def trackback_url
      rdfs = response.body.scan(/<rdf:RDF.*?<\/rdf:RDF>/m)
      rdfs.each do |rdf|
        xml = REXML::Document.new(rdf)
        xml.elements.each('//rdf:Description') do |desc|
          if rdfs.size == 1 || desc.attributes['dc:identifier'] == ping.url
            return desc.attributes['trackback:ping']
          end
        end
      end
      # Didn't find a trackback url, so fall back to the url itself.
      @ping.url
    end

    def send_pingback
      if pingback_url
        send_xml_rpc(pingback_url, 'pingback.ping', origin_url, ping.url)
        true
      else
        false
      end
    end

    def send_trackback
      do_send_trackback(trackback_url, origin_url)
    end

    def do_send_trackback(trackback_url, origin_url)
      trackback_uri = URI.parse(trackback_url)

      post = "title=#{CGI.escape(article.title)}"
      post << "&excerpt=#{CGI.escape(article.html(:body).strip_html[0..254])}"
      post << "&url=#{origin_url}"
      post << "&blog_name=#{CGI.escape(blog.blog_name)}"

      path = trackback_uri.path
      path += "?#{trackback_uri.query}" if trackback_uri.query

      Net::HTTP.start(trackback_uri.host, trackback_uri.port) do |http|
        http.post(path, post, 'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8')
      end
    end

    private

    def initialize(origin_url, ping)
      @origin_url = origin_url
      @ping       = ping
      # Add this call to text filter cause of a strange thing around text_filter. Need to clean text_filter usage !
      ping.article.default_text_filter
      ping.article.text_filter
      # Make sure these are fetched now for thread safety purposes.
      self.article = ping.article
      self.blog    = article.blog
    end
  end

  def send_pingback_or_trackback(origin_url)
    t = Thread.start(Pinger.new(origin_url, self)) do |pinger|
      pinger.send_pingback_or_trackback
    end
    t
  end

  def send_weblogupdatesping(server_url, origin_url)
    t = Thread.start(article.blog.blog_name) do |blog_name|
      send_xml_rpc(url, 'weblogUpdates.ping', blog_name, server_url, origin_url)
    end
    t
  end

  protected

  def send_xml_rpc(xml_rpc_url, name, *args)
    server = XMLRPC::Client.new2(URI.parse(xml_rpc_url).to_s)
    server.call(name, *args)
  rescue => e
    logger.error(e)
  end
end
