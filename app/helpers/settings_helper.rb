module SettingsHelper
  
  def settings_field(field)
    case field.type
    when :string 
      %{<input type="text" value="#{config[field.name]}"  name="fields[#{field.name}]" />}
    when :bool
      %{<input type="checkbox" value="1" #{'checked="checked"' if config[field.name].to_i == 1} name="fields[#{field.name}]" /><input type="hidden" value="0" name="fields[#{field.name}]" />}
    end
  end
end
