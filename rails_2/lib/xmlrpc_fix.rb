# Work around ecto problem
module XMLRPC
  module Convert
    def self.dateTime(str)
      if str =~ /^(-?\d\d\d\d)(\d\d)(\d\d)T(\d\d):(\d\d):(\d\d)Z?$/ then
        a = [$1, $2, $3, $4, $5, $6].collect{|i| i.to_i}
        XMLRPC::DateTime.new(*a)
      else
        raise "wrong dateTime.iso8601 format"
      end
    end
  end
end
