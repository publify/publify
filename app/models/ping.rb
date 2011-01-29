require 'rexml/document'
require 'xmlrpc/client'

class Ping < ActiveRecord::Base
  belongs_to :article

  class Pinger
    attr_accessor :article
    attr_accessor :blog

    def send_pingback_or_trackback
      begin
        @response = Net::HTTP.get_response(URI.parse(ping.url))
        send_pingback or send_trackback
      rescue Timeout::Error => err
        logger.info "Sending pingback or trackback timed out"
        return
      rescue => err
        logger.info "Sending pingback or trackback failed with error: #{err}"
      end
    end

    def pingback_url
      if response["X-Pingback"]
        response["X-Pingback"]
      elsif response.body =~ /<link rel="pingback" href="([^"]+)" ?\/?>/
        $1
      end
    end

    def origin_url
      @origin_url
    end

    def response
      @response
    end

    def ping
      @ping
    end

    def send_xml_rpc(*args)
      ping.send(:send_xml_rpc, *args)
    end

    def trackback_url
      rdfs = response.body.scan(/<rdf:RDF.*?<\/rdf:RDF>/m)
      rdfs.each do |rdf|
        xml = REXML::Document.new(rdf)
        xml.elements.each("//rdf:Description") do |desc|
          if rdfs.size == 1 || desc.attributes["dc:identifier"] == ping.url
            return desc.attributes["trackback:ping"]
          end
        end
      end
      # Didn't find a trackback url, so fall back to the url itself.
      @ping.url
    end

    def send_pingback
      if pingback_url
        send_xml_rpc(pingback_url, "pingback.ping", origin_url, ping.url)
        return true
      else
        return false
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

      net_request = Net::HTTP.start(trackback_uri.host, trackback_uri.port) do |http|
        http.post(path, post, 'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8')
      end
    end

    private

    def initialize(origin_url, ping)
      @origin_url = origin_url
      @ping       = ping
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
      send_xml_rpc(self.url, "weblogUpdates.ping", blog_name,
                   server_url, origin_url)
    end
    t
  end

  protected

  def send_xml_rpc(xml_rpc_url, name, *args)
    begin
      server = XMLRPC::Client.new2(URI.parse(xml_rpc_url).to_s)

      begin
        result = server.call(name, *args)
      rescue XMLRPC::FaultException => e
        logger.error(e)
      end
    rescue Exception => e
      logger.error(e)
    end
  end
end
