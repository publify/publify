module TinyMCEHelper
  class InvalidOption < Exception    
  end
  
  def using_tiny_mce?
    !@uses_tiny_mce.nil?
  end
  
  def tiny_mce_init(options = @tiny_mce_options)
    options ||= {}
    default_options = {:mode => 'textareas',
                       :theme => 'simple'}
    options = default_options.merge(options)
    TinyMCE::OptionValidator.plugins = options[:plugins]
    tinymce_js = "tinyMCE.init({\n"
    i = 0    
    options.stringify_keys.sort.each do |pair|
      key, value = pair[0], pair[1]
      raise InvalidOption.new("Invalid option #{key} passed to tinymce") unless TinyMCE::OptionValidator.valid?(key)
      tinymce_js += "#{key} : "
      case value
      when String, Symbol, Fixnum
        tinymce_js += "'#{value}'"
      when Array
        tinymce_js += '"' + value.join(',') + '"'
      when TrueClass
        tinymce_js += 'true'
      when FalseClass
        tinymce_js += 'false'
      else
        raise InvalidOption.new("Invalid value of type #{value.class} passed for TinyMCE option #{key}")
      end
      (i < options.size - 1) ? tinymce_js += ",\n" : "\n"
      i += 1
    end
    tinymce_js += "\n});"
    javascript_tag tinymce_js
  end
  alias tiny_mce tiny_mce_init
  
  def javascript_include_tiny_mce
    javascript_include_tag RAILS_ENV == 'development' ? "tiny_mce/tiny_mce_src" : "tiny_mce/tiny_mce"
  end
  
  def javascript_include_tiny_mce_if_used
    javascript_include_tiny_mce if @uses_tiny_mce
  end
end