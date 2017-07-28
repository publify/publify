# frozen_string_literal: true

require "rails_helper"

RSpec.describe "With the list of available filters", type: :model do
  let(:flickr_photos) { double "flickr_photos" }
  let(:flickr_photo_info_url) do
    double("flickr_photo_info_url",
           type: "photopage",
           to_s: "http://www.flickr.com/users/scottlaird/31366117")
  end
  let(:flickr_photo_info) do
    double("flickr_photo_info",
           description: "This is Matz, Ruby's creator",
           title: "Matz",
           urls: [flickr_photo_info_url])
  end
  let(:flickr_photo_sizes) do
    [
      {
        "url" => "http://www.flickr.com/photo_zoom.gne?id=31366117&size=sq",
        "height" => "75",
        "source" => "http://photos23.flickr.com/31366117_b1a791d68e_s.jpg",
        "label" => "Square",
        "width" => "75",
      },
      {
        "url" => "http://www.flickr.com/photo_zoom.gne?id=31366117&size=t",
        "height" => "100",
        "source" => "http://photos23.flickr.com/31366117_b1a791d68e_t.jpg",
        "label" => "Thumbnail", "width" => "67"
      },
      {
        "url" => "http://www.flickr.com/photo_zoom.gne?id=31366117&size=s",
        "height" => "240",
        "source" => "http://photos23.flickr.com/31366117_b1a791d68e_m.jpg",
        "label" => "Small",
        "width" => "160",
      },
      {
        "url" => "http://www.flickr.com/photo_zoom.gne?id=31366117&size=m",
        "height" => "500",
        "source" => "http://photos23.flickr.com/31366117_b1a791d68e.jpg",
        "label" => "Medium",
        "width" => "333",
      },
      {
        "url" => "http://www.flickr.com/photo_zoom.gne?id=31366117&size=l",
        "height" => "1024",
        "source" => "http://photos23.flickr.com/31366117_b1a791d68e_b.jpg",
        "label" => "Large",
        "width" => "683",
      },
      {
        "url" => "http://www.flickr.com/photo_zoom.gne?id=31366117&size=o",
        "height" => "1536",
        "source" => "http://photos23.flickr.com/31366117_b1a791d68e_o.jpg",
        "label" => "Original",
        "width" => "1024",
      },
    ]
  end

  before do
    allow(flickr).to receive(:photos).and_return flickr_photos
    allow(flickr_photos).to receive(:getInfo).and_raise "Photo not found"
    allow(flickr_photos).to receive(:getInfo).with(photo_id: "31366117").
      and_return flickr_photo_info
    allow(flickr_photos).to receive(:getSizes).and_return flickr_photo_sizes
  end

  describe "#filter_text" do
    it "works for markdown" do
      filter = TextFilter.markdown
      expect(filter.filter_text('*"foo"*')).to eq "<p><em>&quot;foo&quot;</em></p>"
    end

    xit "works for markdown with smart quotes" do
      filter = TextFilter.markdown_smartypants
      expect(filter.filter_text('*"foo"*')).to eq "<p><em>&#8220;foo&#8221;</em></p>"
    end

    it "works for smart quotes" do
      filter = TextFilter.smartypants
      expect(filter.filter_text('I am "smart"')).to eq "I am &#8220;smart&#8221;"
    end

    context "when using the flickr macro with a plain filter" do
      let(:filter) { TextFilter.none }

      it "shows with default settings" do
        result = filter.
          filter_text('<publify:flickr img="31366117" size="Square" style="float:left"/>')
        expect(result).to eq \
          '<div style="float:left" class="flickrplugin">' \
          '<a href="http://www.flickr.com/users/scottlaird/31366117">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a>' \
          "<p class=\"caption\" style=\"width:75px\">This is Matz, " \
          "Ruby's creator</p></div>"
      end

      it "uses default image size" do
        result = filter.filter_text('<publify:flickr img="31366117"/>')
        expect(result).to eq \
          '<div style="" class="flickrplugin">' \
          '<a href="http://www.flickr.com/users/scottlaird/31366117">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a>' \
          "<p class=\"caption\" style=\"width:75px\">This is Matz, " \
          "Ruby's creator</p></div>"
      end

      it "uses caption" do
        result = filter.filter_text('<publify:flickr img="31366117" caption=""/>')
        expect(result).to eq \
          '<div style="" class="flickrplugin">' \
          '<a href="http://www.flickr.com/users/scottlaird/31366117">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a></div>'
      end

      it "broken_flickr_link" do
        result = filter.filter_text('<publify:flickr img="notaflickrid" />')
        expect(result).to eq \
          "<div class='broken_flickr_link'>" \
          "`notaflickrid' could not be displayed because: <br />" \
          "Photo not found</div>"
      end
    end

    context "when using the lightbox macro" do
      let(:filter) { TextFilter.none }

      it "works" do
        result = filter.
          filter_text('<publify:lightbox img="31366117" thumbsize="Thumbnail"' \
                      ' displaysize="Large" style="float:left"/>')
        expect(result).to eq \
          '<a href="//photos23.flickr.com/31366117_b1a791d68e_b.jpg"' \
          ' data-toggle="lightbox" title="Matz">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_t.jpg"' \
          ' width="67" height="100" alt="Matz" title="Matz"/></a>' \
          "<p class=\"caption\" style=\"width:67px\">This is Matz, Ruby's creator</p>"
      end

      it "uses default thumb image size" do
        result = filter.
          filter_text('<publify:lightbox img="31366117" displaysize="Large"/>')
        expect(result).to eq \
          '<a href="//photos23.flickr.com/31366117_b1a791d68e_b.jpg"' \
          ' data-toggle="lightbox" title="Matz">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a>' \
          "<p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p>"
      end

      it "uses default display image size" do
        result = filter.filter_text('<publify:lightbox img="31366117"/>')
        expect(result).to eq \
          '<a href="//photos23.flickr.com/31366117_b1a791d68e_o.jpg"' \
          ' data-toggle="lightbox" title="Matz">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a>' \
          "<p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p>"
      end

      it "works with caption" do
        result = filter.filter_text('<publify:lightbox img="31366117" caption=""/>')
        expect(result).to eq \
          '<a href="//photos23.flickr.com/31366117_b1a791d68e_o.jpg"' \
          ' data-toggle="lightbox" title="Matz">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a>'
      end
    end

    context "when combining a post-macro with markdown" do
      let(:filter) { TextFilter.markdown }

      it "correctly interprets the macro" do
        result = filter.
          filter_text('<publify:flickr img="31366117" size="Square" style="float:left"/>')
        expect(result).to eq \
          '<div style="float:left" class="flickrplugin">' \
          '<a href="http://www.flickr.com/users/scottlaird/31366117">' \
          '<img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg"' \
          ' width="75" height="75" alt="Matz" title="Matz"/></a>' \
          "<p class=\"caption\" style=\"width:75px\">This is Matz, " \
          "Ruby's creator</p></div>"
      end
    end
  end
end
