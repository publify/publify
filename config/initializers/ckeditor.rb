Ckeditor.setup do |config|
  require 'ckeditor/orm/active_record'

  config.image_file_types = %w(jpg jpeg png gif tiff)
  config.picture_model { Ckeditor::Picture }
  config.default_per_page = 24
  config.assets_languages = %w(en uk)
  config.assets_plugins = %w(image)
  config.authorize_with do
    redirect_to main_app.accounts_path, action: :loging unless authorized?
  end
end
