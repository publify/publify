class TypoTime
  def self.delta(year = nil, month = nil, day = nil)
    return nil if year.nil? && month.nil? && day.nil?
    from = Time.utc(year, month || 1, day || 1)
    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    from..to
  end
end
