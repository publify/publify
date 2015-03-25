# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.configure do

  # Add bower components directory to the load path
  config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

  # Fonts
  config.assets.precompile << /\.(?:png|svg|eot|woff|ttf)$/

  # Stylesheets
  config.assets.precompile += %w(
    enhanced_responsive.css
    enhanced_fixed.css
    publify_admin.css
    editor.css
    accounts.css
    bootstrap.css
    user-styles.css
    coderay.css
    dough/assets/stylesheets/basic.css
    dough/assets/stylesheets/font_files.css
    dough/assets/stylesheets/font_base64.css
  )

  config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
  config.assets.precompile += Ckeditor.assets
  config.assets.precompile += %w(ckeditor/*)

  # Application JavaScript
  config.assets.precompile += %w(
    publify.js
    publify_admin.js
    components/*.js
    dough/assets/js/lib/*.js
    dough/assets/js/components/*.js
  )

  # Vendor JavaScript
  config.assets.precompile += %w(
    jquery.js
    eventsWithPromises/src/eventsWithPromises.js
    requirejs/require.js
    rsvp/rsvp.js
  )
end
