# frozen_string_literal: true

# Based on https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#option-2-preload-a-collapsed-directory

# Collapse sidebars directory since it's not a namespace
sidebars = Rails.root.join("app/models/sidebars")
Rails.autoloaders.main.collapse(sidebars)

unless Rails.application.config.eager_load
  Rails.application.config.to_prepare do
    Rails.autoloaders.main.eager_load_dir(sidebars)
  end
end
