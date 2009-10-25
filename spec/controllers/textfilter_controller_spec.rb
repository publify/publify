require File.dirname(__FILE__) + '/../spec_helper'

require 'flickr_mock'

describe TextfilterController do
  before do
    reset_whiteboard

    get :test_action # set up @url; In Rails 1.0, we can't do url_for without it.
  end

  def blog
    blogs(:default)
  end

  def filter_text(text, filters, filterparams={})
    TextFilter.filter_text(blog, text, self, filters, filterparams)
  end

  def whiteboard
    @whiteboard ||= Hash.new
  end

  def reset_whiteboard
    @whiteboard = nil
  end

  it "test_unknown" do
    text = filter_text('*foo*',[:unknowndoesnotexist])
    assert_equal '*foo*', text
  end

  it "test_smartypants" do
    text = filter_text('"foo"',[:smartypants])
    assert_equal '&#8220;foo&#8221;', text
  end

  it "test_markdown" do
    text = filter_text('*foo*', [:markdown])
    assert_equal '<p><em>foo</em></p>', text

    text = filter_text("foo\n\nbar",[:markdown])
    assert_equal "<p>foo</p>\n\n<p>bar</p>", text
  end

  it "test_filterchain" do
    assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      filter_text('*"foo"*',[:markdown,:smartypants])

    assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      filter_text('*"foo"*',[:doesntexist1,:markdown,"doesn't exist 2",:smartypants,:nopenotmeeither])
  end

  it "test_flickr" do
    assert_equal "<div style=\"float:left\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:flickr img="31366117" size="Square" style="float:left"/>',
        [:macropre,:macropost],
        {'flickr-user' => 'scott@sigkill.org'})

    # Test default image size
    assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:flickr img="31366117"/>',
        [:macropre,:macropost],
        {'flickr-user' => 'scott@sigkill.org'})

    # Test with caption=""
    assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a></div>",
      filter_text('<typo:flickr img="31366117" caption=""/>',
        [:macropre,:macropost],
        {'flickr-user' => 'scott@sigkill.org'})
  end

  it "test_broken_flickr_link" do
    assert_equal %{<div class='broken_flickr_link'>\`notaflickrid\' could not be displayed because: <br />Photo not found</div>},
      filter_text('<typo:flickr img="notaflickrid" />',
        [:macropre, :macropost],
        { 'flickr-user' => 'scott@sigkill.org' })
  end

  describe 'code textfilter' do
    
    describe 'single line' do

      it 'should made nothin if no args' do
        filter_text('<typo:code>foo-code</typo:code>', [:macropre,:macropost]).should == %{<div class="CodeRay"><pre><notextile>foo-code</notextile></pre></div>}
      end

      it 'should parse ruby lang' do
        filter_text('<typo:code lang="ruby">foo-code</typo:code>', [:macropre,:macropost]).should == %{<div class="CodeRay"><pre><notextile><span class=\"CodeRay\">foo-code</span></notextile></pre></div>}
      end

      it 'should parse ruby and xml in same sentence but not in same place' do
        filter_text('<typo:code lang="ruby">foo-code</typo:code> blah blah <typo:code lang="xml">zzz</typo:code>',[:macropre,:macropost]).should == %{<div class="CodeRay"><pre><notextile><span class="CodeRay">foo-code</span></notextile></pre></div> blah blah <div class="CodeRay"><pre><notextile><span class="CodeRay">zzz</span></notextile></pre></div>}
      end

    end

    describe 'multiline' do

      it 'should render ruby' do
      filter_text(%{
<typo:code lang="ruby">
class Foo
  def bar
    @a = "zzz"
  end
end
</typo:code>
},[:macropre,:macropost]).should == %{
<div class=\"CodeRay\"><pre><notextile><span class=\"CodeRay\"><span class=\"r\">class</span> <span class=\"cl\">Foo</span>
  <span class=\"r\">def</span> <span class=\"fu\">bar</span>
    <span class=\"iv\">@a</span> = <span class=\"s\"><span class=\"dl\">&quot;</span><span class=\"k\">zzz</span><span class=\"dl\">&quot;</span></span>
  <span class=\"r\">end</span>
<span class=\"r\">end</span></span></notextile></pre></div>
}
      end
    end
  end

  it "test_named_filter" do
    assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      TextFilter.filter_text_by_name(blog, '*"foo"*', 'markdown smartypants')
  end

  it "test_code_plus_markup_chain" do
    text = <<-EOF
*header text here*

<typo:code lang="ruby">
class test
  def method
    "foo"
  end
end
</typo:code>

_footer text here_

EOF

    expects_markdown = <<-EOF
<p><em>header text here</em></p>

<div class="CodeRay"><pre><span class="CodeRay"><span class="r">class</span> <span class="cl">test</span>
  <span class="r">def</span> <span class="fu">method</span>
    <span class="s"><span class="dl">&quot;</span><span class="k">foo</span><span class="dl">&quot;</span></span>
  <span class="r">end</span>
<span class="r">end</span></span></pre></div>


<p><em>footer text here</em></p>
EOF

    expects_textile = <<-EOF
<p><strong>header text here</strong></p>
<div class="CodeRay"><pre><span class="CodeRay"><span class="r">class</span> <span class="cl">test</span>
  <span class="r">def</span> <span class="fu">method</span>
    <span class="s"><span class="dl">&quot;</span><span class="k">foo</span><span class="dl">&quot;</span></span>
  <span class="r">end</span>
<span class="r">end</span></span></pre></div>
<p><em>footer text here</em></p>
EOF

    assert_equal expects_markdown.strip, TextFilter.filter_text_by_name(blog, text, 'markdown')
    assert_equal expects_textile.strip, TextFilter.filter_text_by_name(blog, text, 'textile')
  end

  it "test_lightbox" do
    assert_equal "<div style=\"float:left\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_t.jpg\" width=\"67\" height=\"100\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:67px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:lightbox img="31366117" thumbsize="Thumbnail" displaysize="Large" style="float:left"/>',
        [:macropre,:macropost],
        {})

#     Test default thumb image size
    assert_equal "<div style=\"\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:lightbox img="31366117" displaysize="Large"/>',
        [:macropre,:macropost],
        {})

#     Test default display image size
    assert_equal "<div style=\"\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:lightbox img="31366117"/>',
        [:macropre,:macropost],
        {})

#     Test with caption=""
    assert_equal "<div style=\"\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a></div>",
      filter_text('<typo:lightbox img="31366117" caption=""/>',
        [:macropre,:macropost],
        {})
  end
end
