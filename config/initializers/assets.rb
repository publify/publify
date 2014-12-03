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
    accounts.css
    bootstrap.css
    user-styles.css
    coderay.css
    dough/assets/stylesheets/basic.css
    dough/assets/stylesheets/font_files.css
    dough/assets/stylesheets/font_base64.css
  )

  # Admin JavaScript
  config.assets.precompile += %w(
    ckeditor/*
  )

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
    jquery/dist/jquery.js
    eventsWithPromises/src/eventsWithPromises.js
    requirejs/require.js
    rsvp/rsvp.js
  )
end
