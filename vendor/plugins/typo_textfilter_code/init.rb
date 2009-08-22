# Include hook code here

begin
  require 'text_filter_plugin'
  require 'typo_textfilter_code'
rescue LoadError => e
  Rails.logger.warn 'Unable to load textfilter'
end

