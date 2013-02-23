require 'spec_helper'

describe "With the list of available filters" do

  attr_reader :blog, :whiteboard
  before(:each) do
    @blog = build_stubbed(:blog)
    @filters = TextFilter.available_filters
    @whiteboard = Hash.new
  end


  describe "#available_filters" do
    subject { @filters }
    it { should include(Typo::Textfilter::Markdown) }
    it { should include(Typo::Textfilter::Smartypants) }
    it { should include(Typo::Textfilter::Htmlfilter) }
    it { should include(Typo::Textfilter::Textile) }
    it { should include(Typo::Textfilter::Flickr) }
    it { should include(Typo::Textfilter::Code) }
    it { should include(Typo::Textfilter::Lightbox) }
    it { should_not include(TextFilterPlugin::Markup) }
    it { should_not include(TextFilterPlugin::Macro) }
  end

  describe "#macro_filters" do
    subject { TextFilter.macro_filters }
    it { should_not include(Typo::Textfilter::Markdown) }
    it { should_not include(Typo::Textfilter::Smartypants) }
    it { should_not include(Typo::Textfilter::Htmlfilter) }
    it { should_not include(Typo::Textfilter::Textile) }
    it { should include(Typo::Textfilter::Flickr) }
    it { should include(Typo::Textfilter::Code) }
    it { should include(Typo::Textfilter::Lightbox) }
    it { should_not include(TextFilterPlugin::Markup) }
    it { should_not include(TextFilterPlugin::Macro) }
  end

  describe "#filter_text" do

    def filter_text(text, filters, filterparams={})
      TextFilter.filter_text(blog, text, self, filters, filterparams)
    end

    it "unknown" do
      text = filter_text('*foo*',[:unknowndoesnotexist])
      text.should == '*foo*'
    end

    it "smartypants" do
      build_stubbed(:smartypants)
      text = filter_text('"foo"',[:smartypants])
      text.should == '&#8220;foo&#8221;'
    end

    it "markdown" do
      build_stubbed(:markdown)
      text = filter_text('*foo*', [:markdown])
      assert_equal '<p><em>foo</em></p>', text

      text = filter_text("foo\n\nbar",[:markdown])
      assert_equal "<p>foo</p>\n\n<p>bar</p>", text
    end

    it "filterchain" do
      build_stubbed(:markdown)
      build_stubbed(:smartypants)
      assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      filter_text('*"foo"*',[:markdown,:smartypants])

      assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      filter_text('*"foo"*',[:doesntexist1,:markdown,"doesn't exist 2",:smartypants,:nopenotmeeither])
    end

    describe "specific typo tags" do

      describe "flickr" do

        it "should show with default settings" do
          assert_equal "<div style=\"float:left\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
            filter_text('<typo:flickr img="31366117" size="Square" style="float:left"/>',
                        [:macropre,:macropost],
                        {'flickr-user' => 'scott@sigkill.org'})
        end

        it "should use default image size" do
          assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
            filter_text('<typo:flickr img="31366117"/>',
                        [:macropre,:macropost],
                        {'flickr-user' => 'scott@sigkill.org'})
        end

        it "should use caption" do
          assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a></div>",
            filter_text('<typo:flickr img="31366117" caption=""/>',
                        [:macropre,:macropost],
                        {'flickr-user' => 'scott@sigkill.org'})
        end

        it "broken_flickr_link" do
          assert_equal %{<div class='broken_flickr_link'>\`notaflickrid\' could not be displayed because: <br />Photo not found</div>},
            filter_text('<typo:flickr img="notaflickrid" />',
                        [:macropre, :macropost],
                        { 'flickr-user' => 'scott@sigkill.org' })
        end
      end

    end #flickr

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
<div class=\"CodeRay\"><pre><notextile><span class=\"CodeRay\"><span class=\"keyword\">class</span> <span class=\"class\">Foo</span>
  <span class=\"keyword\">def</span> <span class=\"function\">bar</span>
    <span class=\"instance-variable\">@a</span> = <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">zzz</span><span class=\"delimiter\">&quot;</span></span>
  <span class=\"keyword\">end</span>
<span class=\"keyword\">end</span></span></notextile></pre></div>
          }
        end
      end #multiline
    end #code textfilter


    it "test_code_plus_markup_chain" do
      build_stubbed :textile
      build_stubbed :markdown

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

<div class=\"CodeRay\"><pre><span class=\"CodeRay\"><span class=\"keyword\">class</span> <span class=\"class\">test</span>
  <span class=\"keyword\">def</span> <span class=\"function\">method</span>
    <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">foo</span><span class=\"delimiter\">&quot;</span></span>
  <span class=\"keyword\">end</span>
<span class=\"keyword\">end</span></span></pre></div>


<p><em>footer text here</em></p>
      EOF

      expects_textile = <<-EOF
<p><strong>header text here</strong></p>\n<div class=\"CodeRay\"><pre><span class=\"CodeRay\"><span class=\"keyword\">class</span> <span class=\"class\">test</span>\n  <span class=\"keyword\">def</span> <span class=\"function\">method</span>\n    <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">foo</span><span class=\"delimiter\">&quot;</span></span>\n  <span class=\"keyword\">end</span>\n<span class=\"keyword\">end</span></span></pre></div>\n<p><em>footer text here</em></p>
      EOF

      assert_equal expects_markdown.strip, TextFilter.filter_text_by_name(blog, text, 'markdown')
      assert_equal expects_textile.strip, TextFilter.filter_text_by_name(blog, text, 'textile')
    end

    context "lightbox" do
      it "should work" do
        assert_equal "<a href=\"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_t.jpg\" width=\"67\" height=\"100\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:67px\">This is Matz, Ruby's creator</p>",
          filter_text('<typo:lightbox img="31366117" thumbsize="Thumbnail" displaysize="Large" style="float:left"/>',
                      [:macropre,:macropost],
                      {})
      end

      it "shoudl use default thumb image size" do
        assert_equal "<a href=\"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p>",
          filter_text('<typo:lightbox img="31366117" displaysize="Large"/>',
                      [:macropre,:macropost],
                      {})
      end

      it "should use default display image size" do
        assert_equal "<a href=\"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p>",
          filter_text('<typo:lightbox img="31366117"/>',
                      [:macropre,:macropost],
                      {})
      end

      it "should work with caption" do
        assert_equal "<a href=\"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a>",
          filter_text('<typo:lightbox img="31366117" caption=""/>',
                      [:macropre,:macropost],
                      {})
      end
    end

    describe "combining a post-macro" do
      describe "with markdown" do
        it "correctly interprets the macro" do
          result = filter_text('<typo:flickr img="31366117" size="Square" style="float:left"/>',
                               [:macropre, :markdown, :macropost])
          result.should =~ %r{<div style="float:left" class="flickrplugin"><a href="http://www.flickr.com/users/scottlaird/31366117"><img src="http://photos23.flickr.com/31366117_b1a791d68e_s.jpg" width="75" height="75" alt="Matz" title="Matz"/></a><p class="caption" style="width:75px">This is Matz, Ruby's creator</p></div>}
        end
      end

      describe "with markdown" do
        it "correctly interprets the macro" do
          result = filter_text('<typo:flickr img="31366117" size="Square" style="float:left"/>',
                               [:macropre, :textile, :macropost])
          result.should == "<div style=\"float:left\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>"
        end
      end
    end

  end # #filter_text

  it "#filter text by name" do
    t = build_stubbed('markdown smartypants')
    result = TextFilter.filter_text_by_name(blog, '*"foo"*', 'markdown smartypants')
    result.should == '<p><em>&#8220;foo&#8221;</em></p>'
  end

end

