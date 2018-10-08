# frozen_string_literal: true

class ThemeController < ContentController
  # Allow javascripts via Get request
  skip_before_action :verify_authenticity_token, only: :javascripts

  def stylesheets
    render_theme_item(:stylesheets, params[:filename], 'text/css; charset=utf-8')
  end

  def javascripts
    render_theme_item(:javascripts, params[:filename], 'text/javascript; charset=utf-8')
  end

  def images
    render_theme_item(:images, params[:filename])
  end

  def fonts
    render_theme_item(:fonts, params[:filename])
  end

  def error
    head :not_found
  end

  def static_view_test; end

  private

  def render_theme_item(type, file, mime = nil)
    return render_not_found if file.split(%r{[\\/]}).include?('..')

    src = this_blog.current_theme.path + "/#{type}/#{file}"
    return render_not_found unless File.exist? src

    mime ||= mime_for(file)
    send_file(src, type: mime, disposition: 'inline', stream: true)
  end

  def render_not_found
    render plain: 'Not Found', status: :not_found
  end

  def mime_for(filename)
    case filename.downcase
    when /\.js$/
      'text/javascript'
    when /\.css$/
      'text/css'
    when /\.gif$/
      'image/gif'
    when /(\.jpg|\.jpeg)$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    when /\.swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end
end
