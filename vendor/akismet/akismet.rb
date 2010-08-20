# Akismet
#
# Author:: David Czarnecki
# Copyright:: Copyright (c) 2005 - David Czarnecki
# License:: BSD
#
# Heavily modified for Typo by Scott Laird
#
class Akismet
  require 'net/http'
  require 'uri'
  require 'timeout'

  STANDARD_HEADERS = {
    'User-Agent' => "Typo/#{TYPO_VERSION} | Akismet Ruby API/1.0",
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
  #options[:user_ip] = user_ip
  #options[:user_agent] = user_agent
  #options[:referrer] = referrer
  #options[:permalink] = permalink
  #options[:comment_type] = comment_type
  #options[:comment_author] = comment_author
  #options[:comment_author_email] = comment_author_email
  #options[:comment_author_url] = comment_author_url
  #options[:comment_content] = comment_content

  def callAkismet(akismet_function, options = {})
    result = false
    begin
      Timeout.timeout(5) do
        http = Net::HTTP.new("#{@apiKey}.rest.akismet.com", 80, @proxyHost, @proxyPort)
        path = "/1.1/#{akismet_function}"

        options[:blog] = @blog
        params=[]

        options.each_key do |key|
          params.push "#{key}=#{CGI.escape(options[key].to_s)}"
        end

        data = params.join('&')
        resp, data = http.post(path, data, STANDARD_HEADERS)

        unless data == 'true' or data == 'false' or data == ''
          STDERR.puts "AKISMET error: #{data}"
        end

        result = (data == "true" or data == '')
      end
    rescue => err
      STDERR.puts "AKISMET exception: #{err}"
    end

    return result
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
  def commentCheck(options = {})
    return callAkismet('comment-check', options)
  end

  # This call is for submitting comments that weren't marked as spam but should have been. It takes identical arguments as comment check.
  # The call parameters are the same as for the #commentCheck method.
  def submitSpam(options = {})
    callAkismet('submit-spam', options)
  end

  # This call is intended for the marking of false positives, things that were incorrectly marked as spam. It takes identical arguments as comment check and submit spam.
  # The call parameters are the same as for the #commentCheck method.
  def submitHam(options = {})
    callAkismet('submit-ham', options)
  end
end