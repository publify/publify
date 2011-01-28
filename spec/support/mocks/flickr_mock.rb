#remove_const "Flickr"

class FlickRaw::Flickr
  def initialize
  end

  def photos
    Photos.new
  end

  class Photos
    def getInfo(params)
      Photo.new(params[:photo_id])
    end

    def getSizes(params)
      [{"url"=>"http://www.flickr.com/photo_zoom.gne?id=31366117&size=sq", "height"=>"75", "source"=>"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg", "label"=>"Square", "width"=>"75"}, {"url"=>"http://www.flickr.com/photo_zoom.gne?id=31366117&size=t", "height"=>"100", "source"=>"http://photos23.flickr.com/31366117_b1a791d68e_t.jpg", "label"=>"Thumbnail", "width"=>"67"}, {"url"=>"http://www.flickr.com/photo_zoom.gne?id=31366117&size=s", "height"=>"240", "source"=>"http://photos23.flickr.com/31366117_b1a791d68e_m.jpg", "label"=>"Small", "width"=>"160"}, {"url"=>"http://www.flickr.com/photo_zoom.gne?id=31366117&size=m", "height"=>"500", "source"=>"http://photos23.flickr.com/31366117_b1a791d68e.jpg", "label"=>"Medium", "width"=>"333"}, {"url"=>"http://www.flickr.com/photo_zoom.gne?id=31366117&size=l", "height"=>"1024", "source"=>"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg", "label"=>"Large", "width"=>"683"}, {"url"=>"http://www.flickr.com/photo_zoom.gne?id=31366117&size=o", "height"=>"1536", "source"=>"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg", "label"=>"Original", "width"=>"1024"}]
    end
  end

  class Photo
    def initialize(photoid)
      unless photoid == '31366117'
        raise 'Photo not found'
      end
    end

    def description
      "This is Matz, Ruby's creator"
    end

    def title
      "Matz"
    end

    def urls
      [Url.new]
    end
  end

  class Url
    def type
      "photopage"
    end

    def to_s
      "http://www.flickr.com/users/scottlaird/31366117"
    end
  end
end
