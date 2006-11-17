require 'net/http'
require 'flickr/flickr'

class Typo
  class Textfilter
    class Lightbox < TextFilterPlugin::MacroPost
      plugin_display_name "Lightbox"
      plugin_description "Automatically generate tags for images displayed in a lightbox"

      def self.help_text
        %{
You can use `<typo:lightbox>` to display images from [Flickr](http://flickr.com)
or a provided URL which, when clicked, will be shown in a lightbox using Lokesh Dhakar's
[Lightbox](http://www.huddletogether.com/projects/lightbox/) Javascript

Example:

    <typo:lightbox img="31367273" thumbsize="thumbnail" displaysize="original"/>
    <typo:lightbox src="/files/myimage.png" thumbsrc="/files/myimage-thumb.png"/>

The first will produce an `<img>` tag showing image number 31367273 from Flickr using the thumbnail image size.  The image will be linked to the original image file from Flickr.  When the link is clicked, the larger picture will be overlaid
on top of the existing page instead of taking you over to the Flickr site.
The second will do the same but use the `src` URL as the large picture and the `thumbsrc` URL as the thumbnail image.
To understand what this looks like, have a peek at Lokesh Dhakar's
[examples](http://www.huddletogether.com/projects/lightbox/).
It will also have a
comment block attached if a description has been attached to the picture in Flickr or the caption attribute is used.

For theme writers, the link is enclosed in a div tag with a "lightboxplugin"
class.  Because this filter requires javascript and css include files, it
will only work with themes using the `<%= page_header %>` convenience function
in their layouts. As of this writing only Azure does this.

This macro takes a number of parameters:

Flickr attributes:

* **img** The Flickr image ID of the picture that you wish to use.  This shows up in the URL whenever
  you're viewing a picture in Flickr; for example, the image ID for <http://flickr.com/photos/scottlaird/31367273>
  is 31367273.
* **thumbsize** The image size that you'd like to display.  Typically you would use square, thumbnail or small.  Options are:
  * square (75x75)
  * thumbnail (maximum size 100 pixels)
  * small (maximum size 240 pixels)
  * medium (maximum size 500 pixels)
  * large (maximum size 1024 pixels)
  * original
* **displaysize** The image size for the lightbox overlay shown when the user clicks the thumbnail.  Options are the same as for thumbsize, but typically you would use medium or large.  If your image files are quite large on Flickr you probably want to avoid using original.

Direct URL attributes:

* **src** The URL to the picture you wish to use.
* **thumbsrc** The URL to the thumbnail you would like to use. If this is not provided, the original picture will be used with the width and height properties of the `<img>` tag set to 100x100.

Common attributes:

* **style** This is passed through to the enclosing `<div>` that this macro generates.  To float the
  image on the right, use `style="float:right"`.
* **caption** The caption displayed below the image.  By default, this is Flickr's description of the image.
  to disable, use `caption=""`.
* **title** The tooltip title associated with the image.  Defaults to Flickr's image title.
* **alt** The alt text associated with the image.  By default, this is the same as the title.
}
      end

      def self.macrofilter(blog,content,attrib,params,text="")
        style         = attrib['style']
        caption       = attrib['caption']
        title         = attrib['title']
        alt           = attrib['alt']

        img           = attrib['img']
        if img
          thumbsize     = attrib['thumbsize'] || "square"
          displaysize   = attrib['displaysize'] || "original"

          flickr = ::Flickr.new(FLICKR_KEY)
          flickrimage = ::Flickr::Photo.new(img)
          sizes = flickrimage.sizes

          thumbdetails = sizes.find {|s| s['label'].downcase == thumbsize.downcase } || sizes.first
          displaydetails = sizes.find {|s| s['label'].downcase == displaysize.downcase } || sizes.first

          width  = thumbdetails['width']
          height = thumbdetails['height']
          thumburl    = thumbdetails['source']

          displayurl    = displaydetails['source']

          caption ||= flickrimage.description
          title ||= flickrimage.title
          alt ||= title
        else
          thumburl = attrib['thumbsrc']
          displayurl = attrib['src']

          if thumburl.empty?
            thumburl = displayurl
            width = 100
            height = 100
          else
            width = height = nil
          end
        end

        if(caption.blank?)
          captioncode=""
        else
          captioncode = "<p class=\"caption\" style=\"width:#{width}px\">#{caption}</p>"
        end

        set_whiteboard blog, content unless content.nil?

        %{<div style="#{style}" class="lightboxplugin"><a href="#{displayurl}" rel="lightbox" title="#{title}"><img src="#{thumburl}" #{%{width="#{width}" } unless width.nil?}#{%{height="#{height}" } unless height.nil?}alt="#{alt}" title="#{title}"/></a>#{captioncode}</div>}
      end

      def self.set_whiteboard(blog, content)
        content.whiteboard['page_header_lightbox'] = <<-HTML
          <link href="#{blog.base_url}/stylesheets/lightbox.css" media="all" rel="Stylesheet" type="text/css" />
          <script src="#{blog.base_url}/javascripts/lightbox.js" type="text/javascript"></script>
        HTML
      end
    end
  end
end
