Ckeditor.setup do |config|
  require 'ckeditor/orm/active_record'

  config.image_file_types = %w(jpg jpeg png gif tiff)
  config.attachment_file_types = %w(doc docx xls odt ods pdf)
  config.picture_model { Ckeditor::Picture }
  config.attachment_file_model { Ckeditor::AttachmentFile }
  config.default_per_page = 24
  config.assets_languages = %w(en uk)
  config.assets_plugins = %w(image)
  config.authorize_with do
    redirect_to main_app.accounts_path unless authorized?
  end
end
