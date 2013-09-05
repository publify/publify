class PublifyTime
  def self.delta(year = nil, month = nil, day = nil)
    return nil if year.nil? && month.nil? && day.nil?
    year  = year.to_i  unless year.nil?
    month = month.to_i unless month.nil?
    day   = day.to_i   unless day.nil?
    from  = Time.zone.local(year, month, day)
    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    from..to
  end
end
