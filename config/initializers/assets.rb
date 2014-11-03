Rails.application.configure do

  # Add bower components directory to the load path
  config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

  # Fonts
  config.assets.precompile << /\.(?:png|svg|eot|woff|ttf)$/

  # Stylesheets
  config.assets.precompile += %w(
    publify.js
    enhanced_responsive.css
    enhanced_fixed.css
    publify_admin.js
    publify_admin.css
    accounts.css
    bootstrap.css
    user-styles.css
    coderay.css
    dough/assets/stylesheets/basic.css
    dough/assets/stylesheets/font_files.css
    dough/assets/stylesheets/font_base64.css
    jquery/dist/jquery.js
    requirejs/require.js
  )
end
