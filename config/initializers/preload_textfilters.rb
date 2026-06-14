# frozen_string_literal: true

# Based on https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#option-3-preload-a-regular-directory

unless Rails.application.config.eager_load
  Rails.application.config.to_prepare do
    textfilters = Rails.root.join("lib/publify_app/textfilter")
    Rails.autoloaders.main.eager_load_dir(textfilters)
  end
end
