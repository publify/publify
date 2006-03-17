require_dependency 'blacklist_pattern'

class SpamProtection

  IP_RBLS = [ 'opm.blitzed.us', 'bsb.empty.us' ]
  HOST_RBLS = [ 'multi.surbl.org', 'bsb.empty.us' ]
  SECOND_LEVEL = [ 'co', 'com', 'net', 'org', 'gov' ]

  def article_closed?(record)
    return false if this_blog.sp_article_auto_close.zero? or not record.new_record?

    if record.article.created_at.to_i < this_blog.sp_article_auto_close.days.ago.to_i
      logger.info("[SP] Blocked interaction with #{record.article.title}")
      return true
    end
  end

  def is_spam?(string)
    return false unless this_blog.sp_global
    return false if string.blank?

    reason = catch(:hit) do
      case string
        when Format::IP_ADDRESS: self.scan_ip(string)
        when Format::HTTP_URI: self.scan_uri(URI.parse(string).host) rescue URI::InvalidURIError
        else self.scan_text(string)
      end
    end

    if reason
      logger.info("[SP] Hit: #{reason}")
      return true
    end
  end

  protected

  def scan_ip(ip_address)
    logger.info("[SP] Scanning IP #{ip_address}")
    query_rbls(IP_RBLS, ip_address.split('.').reverse.join('.'))
  end

  def scan_text(string)
    # Scan contained URLs
    uri_list = string.scan(/(http:\/\/[^\s"]+)/m).flatten

    # Check for URL count limit
    if this_blog.sp_url_limit > 0
      throw :hit, "Hard URL Limit hit: #{uri_list.size} > #{this_blog.sp_url_limit}" if uri_list.size > this_blog.sp_url_limit
    end

    uri_list.collect { |uri| URI.parse(uri).host rescue nil }.uniq.compact.each do |host|
      scan_uri(host)
    end

    # Pattern scanning
    BlacklistPattern.find_all.each do |pattern|
      logger.info("[SP] Scanning for #{pattern.class} #{pattern.pattern}")

      if pattern.kind_of?(RegexPattern)
        throw :hit, "Regex #{pattern.pattern} matched" if string.match(/#{pattern.pattern}/)
      else
        throw :hit, "String #{pattern.pattern} matched" if string.match(/\b#{Regexp.quote(pattern.pattern)}\b/)
      end
    end

    return false
  end

  def scan_uri(host)
    return scan_ip(host) if host =~ Format::IP_ADDRESS

    host_parts = host.split('.').reverse
    domain = Array.new

    # Check for two level TLD
    (SECOND_LEVEL.include?(host_parts[1]) ? 3:2).times do
      domain.unshift(host_parts.shift)
    end

    logger.info("[SP] Scanning domain #{domain.join('.')}")
    query_rbls(HOST_RBLS, host, domain.join('.'))
  end

  def query_rbls(rbls, *subdomains)
    rbls.each do |rbl|
      subdomains.uniq.each do |d|
        begin
          response = IPSocket.getaddress([d, rbl].join('.'))
          throw :hit, "#{rbl} positively resolved subdomain #{d} => #{response}"
        rescue SocketError
          # NXDOMAIN response => negative:  d is not in RBL
        end
      end
    end
    return false
  end

  def logger
    @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDOUT)
  end
end

module ActiveRecord
  module Validations
    module ClassMethods
      def validates_against_spamdb(*attr_names)
        configuration = { :message => "blocked by SpamProtection" }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          record.errors.add(attr_name, configuration[:message]) if SpamProtection.new.is_spam?(value)
        end
      end
      def validates_age_of(*attr_names)
        configuration = { :message => "points to an item that is no longer available for interaction"}
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          next unless value.to_i > 0
          record.errors.add(attr_name, configuration[:message]) if SpamProtection.new.article_closed?(record)
        end
      end
    end
  end
end
