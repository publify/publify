xml.instruct! :xml, :version=>"1.0", :encoding=>"iso-8859-1"
xml.response do
  xml.error(@error_message.blank? ? 0 : 1)
  xml.message(@error_message) if @error_message
end
