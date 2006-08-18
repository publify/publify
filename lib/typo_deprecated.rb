class TypoDeprecated < StandardError; end

def typo_deprecated(message=nil)
  $typo_deprecated ||= {}
  deprecated_method = caller[0].gsub(/.*\`(.*)\'.*/,'\1')
  called_from = caller[1].gsub(%r{.*/\.\.\/(.*)$},'\1')
  
  warning = "Deprecation warning: #{deprecated_method} called from #{called_from}  #{message}"


  unless ($typo_deprecated[warning])
    RAILS_DEFAULT_LOGGER.error "\n**** #{warning} ****\n"
    $typo_deprecated[warning] = true
  end
  
  if ENV['RAILS_ENV'] == 'test'
    raise TypoDeprecated, warning
  end
end
