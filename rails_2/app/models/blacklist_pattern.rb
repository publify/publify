class BlacklistPattern < ActiveRecord::Base
end

class RegexPattern < BlacklistPattern
  def matches?(string)
    string.match(/#{pattern}/)
  end

  def to_s
    "Regex /#{pattern}/"
  end
end

class StringPattern < BlacklistPattern
  def matches?(string)
    string.match(/\b#{Regexp.quote(pattern)}\b/)
  end

  def to_s
    "String '#{pattern}'"
  end
end
