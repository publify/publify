class PublifyTime
  def self.delta(year = nil, month = nil, day = nil)
    return nil if year.nil? && month.nil? && day.nil?
    year  = year.to_i          unless year.nil?
    month = month.to_i         unless month.nil?
    day   = day.to_i           unless day.nil?
    return nil if year.zero?
    from  = Time.zone.local(year, month, day)
    to    = from.end_of_year
    to    = from.end_of_month  unless month.blank?
    to    = from.end_of_day    unless day.blank?
    from..to
  end

  def self.delta_like(str)
    case str
    when /(\d{4})-(\d{2})-(\d{2})/
      delta(Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3))

    when /(\d{4})-(\d{2})/
      delta(Regexp.last_match(1), Regexp.last_match(2))

    when /(\d{4})/
      delta(Regexp.last_match(1))

    else
      str
    end
  end
end
