# Akismet
#
# Author:: David Czarnecki
# Copyright:: Copyright (c) 2005 - David Czarnecki
# License:: BSD
class Akismet

  require 'net/HTTP'
  require 'uri'
  
  STANDARD_HEADERS = {
    'User-Agent' => 'Akismet Ruby API/1.0',
    'Content-Type' => 'application/x-www-form-urlencoded'
  }
  
  # Instance variables
  @apiKey
  @blog
  @verifiedKey
  @proxyPort = nil
  @proxyHost = nil

  # Create a new instance of the Akismet class
  #
  # apiKey 
  #   Your Akismet API key
  # blog 
  #   The blog associated with your api key
  def initialize(apiKey, blog)
    @apiKey = apiKey
    @blog = blog
    @verifiedKey = false
  end
  
  # Set proxy information 
  #
  # proxyHost
  #   Hostname for the proxy to use
  # proxyPort
  #   Port for the proxy
  def setProxy(proxyHost, proxyPort) 
    @proxyPort = proxyPort
    @proxyHost = proxyHost
  end
    
  # Call to check and verify your API key. You may then call the #hasVerifiedKey method to see if your key has been validated.
  def verifyAPIKey()
    http = Net::HTTP.new('rest.akismet.com', 80, @proxyHost, @proxyPort)
    path = '/1.1/verify-key'
    
    data="key=#{@apiKey}&blog=#{@blog}"
    
    resp, data = http.post(path, data, STANDARD_HEADERS)
    @verifiedKey = (data == "valid")
  end
 
  # Returns <tt>true</tt> if the API key has been verified, <tt>false</tt> otherwise
  def hasVerifiedKey()
    return @verifiedKey
  end
  
  # Internal call to Akismet. Prepares the data for posting to the Akismet service.
  #
  # akismet_function
  #   The Akismet function that should be called
  # user_ip (required)
  #    IP address of the comment submitter.
  # user_agent (required)
  #    User agent information.
  # referrer (note spelling)
  #    The content of the HTTP_REFERER header should be sent here.
  # permalink
  #    The permanent location of the entry the comment was submitted to.
  # comment_type
  #    May be blank, comment, trackback, pingback, or a made up value like "registration".
  # comment_author
  #    Submitted name with the comment
  # comment_author_email
  #    Submitted email address
  # comment_author_url
  #    Commenter URL.
  # comment_content
  #    The content that was submitted.
  # Other server enviroment variables
  #    In PHP there is an array of enviroment variables called $_SERVER which contains information about the web server itself as well as a key/value for every HTTP header sent with the request. This data is highly useful to Akismet as how the submited content interacts with the server can be very telling, so please include as much information as possible.  
  def callAkismet(akismet_function, user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
    http = Net::HTTP.new("#{@apiKey}.rest.akismet.com", 80, @proxyHost, @proxyPort)
    path = "/1.1/#{akismet_function}"        
    
    data = "user_ip=#{user_ip}&user_agent=#{user_agent}&referrer=#{referrer}&permalink=#{permalink}&comment_type=#{comment_type}&comment_author=#{comment_author}&comment_author_email=#{comment_author_email}&comment_author_url=#{comment_author_url}&comment_content=#{comment_content}"
    if (other != nil) 
      other.each_pair {|key, value| data.concat("&#{key}=#{value}")}
    end
    data = URI.escape(data)
            
    resp, data = http.post(path, data, STANDARD_HEADERS)
        
    return (data != "false")
  end
  
  protected :callAkismet

  # This is basically the core of everything. This call takes a number of arguments and characteristics about the submitted content and then returns a thumbs up or thumbs down. Almost everything is optional, but performance can drop dramatically if you exclude certain elements.
  #
  # user_ip (required)
  #    IP address of the comment submitter.
  # user_agent (required)
  #    User agent information.
  # referrer (note spelling)
  #    The content of the HTTP_REFERER header should be sent here.
  # permalink
  #    The permanent location of the entry the comment was submitted to.
  # comment_type
  #    May be blank, comment, trackback, pingback, or a made up value like "registration".
  # comment_author
  #    Submitted name with the comment
  # comment_author_email
  #    Submitted email address
  # comment_author_url
  #    Commenter URL.
  # comment_content
  #    The content that was submitted.
  # Other server enviroment variables
  #    In PHP there is an array of enviroment variables called $_SERVER which contains information about the web server itself as well as a key/value for every HTTP header sent with the request. This data is highly useful to Akismet as how the submited content interacts with the server can be very telling, so please include as much information as possible.
  def commentCheck(user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
    return callAkismet('comment-check', user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
  end
  
  # This call is for submitting comments that weren't marked as spam but should have been. It takes identical arguments as comment check.
  # The call parameters are the same as for the #commentCheck method.
  def submitSpam(user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
    callAkismet('submit-spam', user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
  end
  
  # This call is intended for the marking of false positives, things that were incorrectly marked as spam. It takes identical arguments as comment check and submit spam.
  # The call parameters are the same as for the #commentCheck method.
  def submitHam(user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
    callAkismet('submit-ham', user_ip, user_agent, referrer, permalink, comment_type, comment_author, comment_author_email, comment_author_url, comment_content, other)
  end
end