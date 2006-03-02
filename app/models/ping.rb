require 'rexml/document'

class Ping < ActiveRecord::Base
  belongs_to :article

  def send_pingback_or_trackback(origin_url)

    # Get the contents of the referenced URL, find pingback
    # autodiscovery information, or, if it doesn't exist, trackback
    # autodiscovery information and send a pingback or a trackback.
    #
    # Pingbacks are discovered through the X-Pingback HTTP header or a
    # <link> tag in an HTML document as described in
    # http://www.hixie.ch/specs/pingback/pingback#TOC2.3.
    #
    # Trackbacks are discovered via a RDF document inside the
    # referenced HTML as shown in
    # http://www.sixapart.com/pronet/docs/trackback_spec.

    uri = URI.parse(self.url)

    begin
      response = Net::HTTP.get_response(uri)

      if response["X-Pingback"]
        send_pingback(origin_url, response["X-Pingback"])
      elsif response.body=~ /<link rel="pingback" href="([^"]+)" ?\/?>/
        send_pingback(origin_url, $1)
      else
        rdfs = response.body.scan(/<rdf:RDF.*?<\/rdf:RDF>/m)
        trackback_url = nil

        rdfs.each do |rdf|
          xml = REXML::Document.new(rdf)
          xml.elements.each("//rdf:Description") do |desc|
            if rdfs.size == 1 or desc.attributes["dc:identifier"] == self.url
              send_trackback(origin_url, desc.attributes["trackback:ping"])
              break
            end
          end
        end
      end
    rescue Timeout::Error => err
      return
    rescue => err
      # Ignore
    end
  end

  def send_pingback(origin_url, pingback_url)
    send_xml_rpc(pingback_url, "pingback.ping", origin_url, self.url)
  end

  def send_trackback(origin_url, trackback_url = self.url)
    trackback_uri = URI.parse(trackback_url)

    post = "title=#{URI.escape(article.title)}"
    post << "&excerpt=#{URI.escape(article.body_html.strip_html[0..254])}"
    post << "&url=#{origin_url}"
    post << "&blog_name=#{URI.escape(config[:blog_name])}"

    Net::HTTP.start(trackback_uri.host, trackback_uri.port) do |http|
      path = trackback_uri.path
      path += "?#{trackback_uri.query}" if trackback_uri.query
      http.post(path, post, 'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8')
    end
  end

  def send_weblogupdatesping(server_url, origin_url)
    send_xml_rpc(self.url, "weblogUpdates.ping", config[:blog_name], server_url, origin_url)
  end

  protected

  def send_xml_rpc(xml_rpc_url, name, *args)
    begin
      server = XMLRPC::Client.new2(URI.parse(xml_rpc_url).to_s)

      begin
        result = server.call(name, args)
      rescue XMLRPC::FaultException => e
        logger.error(e)
      end
    rescue Exception => e
      logger.error(e)
    end
  end
end
