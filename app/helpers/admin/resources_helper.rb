module Admin::ResourcesHelper
  def show_thumbnail(image)
    image.create_thumbnail unless File.exists? "#{::Rails.root.to_s}/public/files/thumb_#{image.filename}"

    "<img class='tumb' src='#{this_blog.base_url}/files/thumb_#{image.filename}' alt='#{this_blog.base_url}/files/#{image.filename}' />"
  end

end
