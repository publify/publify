class BlacklistPattern < ActiveRecord::Base
end

class RegexPattern < BlacklistPattern
end

class StringPattern < BlacklistPattern
end
