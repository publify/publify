require 'rails_helper'

describe 'With the list of available filters', type: :model do
  attr_reader :blog, :whiteboard
  before(:each) do
    @blog = build_stubbed(:blog)
    @filters = TextFilter.available_filters
    @whiteboard = {}
  end

  describe '#available_filters' do
    subject { @filters }
    it { is_expected.to include(PublifyApp::Textfilter::Markdown) }
    it { is_expected.to include(PublifyApp::Textfilter::Smartypants) }
    it { is_expected.to include(PublifyApp::Textfilter::Htmlfilter) }
    it { is_expected.to include(PublifyApp::Textfilter::Textile) }
    it { is_expected.to include(PublifyApp::Textfilter::Flickr) }
    it { is_expected.to include(PublifyApp::Textfilter::Code) }
    it { is_expected.to include(PublifyApp::Textfilter::Lightbox) }
    it { is_expected.to include(PublifyApp::Textfilter::Twitterfilter) }
    it { is_expected.not_to include(TextFilterPlugin::Markup) }
    it { is_expected.not_to include(TextFilterPlugin::Macro) }
  end

  describe '#macro_filters' do
    subject { TextFilter.macro_filters }
    it { is_expected.not_to include(PublifyApp::Textfilter::Markdown) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Smartypants) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Htmlfilter) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Textile) }
    it { is_expected.to include(PublifyApp::Textfilter::Flickr) }
    it { is_expected.to include(PublifyApp::Textfilter::Code) }
    it { is_expected.to include(PublifyApp::Textfilter::Lightbox) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Twitterfilter) }
    it { is_expected.not_to include(TextFilterPlugin::Markup) }
    it { is_expected.not_to include(TextFilterPlugin::Macro) }
  end

  describe 'Twitter filter' do
    def filter_text(text, filters, filterparams = {})
      TextFilter.filter_text(blog, text, self, filters, filterparams)
    end

    it 'should replace a hashtag with a proper URL to Twitter search' do
      text = filter_text('A test tweet with a #hashtag', [:twitterfilter])
      expect(text).to eq("A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&src=tren&mode=realtime'>#hashtag</a>")
    end

    it 'should replace a @mention by a proper URL to the twitter account' do
      text = filter_text('A test tweet with a @mention', [:twitterfilter])
      expect(text).to eq("A test tweet with a <a href='https://twitter.com/mention'>@mention</a>")
    end

    it 'should replace a http URL by a proper link' do
      text = filter_text('A test tweet with a http://link.com', [:twitterfilter])
      expect(text).to eq("A test tweet with a <a href='http://link.com'>http://link.com</a>")
    end

    it 'should replace a https URL with a proper link' do
      text = filter_text('A test tweet with a https://link.com', [:twitterfilter])
      expect(text).to eq("A test tweet with a <a href='https://link.com'>https://link.com</a>")
    end
  end

  describe '#filter_text' do
    def filter_text(text, filters, filterparams = {})
      TextFilter.filter_text(blog, text, self, filters, filterparams)
    end

    it 'unknown' do
      text = filter_text('*foo*', [:unknowndoesnotexist])
      expect(text).to eq('*foo*')
    end

    it 'Twitter' do
      text = filter_text('A test tweet with a #hashtag and a @mention', [:twitterfilter])
      expect(text).to eq("A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&src=tren&mode=realtime'>#hashtag</a> and a <a href='https://twitter.com/mention'>@mention</a>")
    end

    it 'smartypants' do
      build_stubbed(:smartypants)
      text = filter_text('"foo"', [:smartypants])
      expect(text).to eq('&#8220;foo&#8221;')
    end

    it 'markdown' do
      build_stubbed(:markdown)
      text = filter_text('*foo*', [:markdown])
      assert_equal '<p><em>foo</em></p>', text

      text = filter_text("foo\n\nbar", [:markdown])
      assert_equal "<p>foo</p>\n\n<p>bar</p>", text
    end

    it 'filterchain' do
      build_stubbed(:markdown)
      build_stubbed(:smartypants)
      assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
                   filter_text('*"foo"*', [:markdown, :smartypants])

      assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
                   filter_text('*"foo"*', [:doesntexist1, :markdown, "doesn't exist 2", :smartypants, :nopenotmeeither])
    end

    describe 'specific publify tags' do
      describe 'flickr' do
        it 'should show with default settings' do
          assert_equal "<div style=\"float:left\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
                       filter_text('<publify:flickr img="31366117" size="Square" style="float:left"/>',
                                   [:macropre, :macropost],
                                   'flickr-user' => 'scott@sigkill.org')
        end

        it 'should use default image size' do
          assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
                       filter_text('<publify:flickr img="31366117"/>',
                                   [:macropre, :macropost],
                                   'flickr-user' => 'scott@sigkill.org')
        end

        it 'should use caption' do
          assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a></div>",
                       filter_text('<publify:flickr img="31366117" caption=""/>',
                                   [:macropre, :macropost],
                                   'flickr-user' => 'scott@sigkill.org')
        end

        it 'broken_flickr_link' do
          assert_equal %(<div class='broken_flickr_link'>`notaflickrid' could not be displayed because: <br />Photo not found</div>),
                       filter_text('<publify:flickr img="notaflickrid" />',
                                   [:macropre, :macropost],
                                   'flickr-user' => 'scott@sigkill.org')
        end
      end
    end # flickr

    describe 'code textfilter' do
      describe 'single line' do
        it 'should made nothin if no args' do
          expect(filter_text('<publify:code>foo-code</publify:code>', [:macropre, :macropost])).to eq(%(<div class="CodeRay"><pre><notextile>foo-code</notextile></pre></div>))
        end

        it 'should parse ruby lang' do
          expect(filter_text('<publify:code lang="ruby">foo-code</publify:code>', [:macropre, :macropost])).to eq(%(<div class="CodeRay"><pre><notextile><span class="CodeRay">foo-code</span></notextile></pre></div>))
        end

        it 'should parse ruby and xml in same sentence but not in same place' do
          expect(filter_text('<publify:code lang="ruby">foo-code</publify:code> blah blah <publify:code lang="xml">zzz</publify:code>', [:macropre, :macropost])).to eq(%(<div class="CodeRay"><pre><notextile><span class="CodeRay">foo-code</span></notextile></pre></div> blah blah <div class="CodeRay"><pre><notextile><span class="CodeRay">zzz</span></notextile></pre></div>))
        end
      end
      describe 'multiline' do
        it 'should render ruby' do
          expect(filter_text(%(
<publify:code lang="ruby">
class Foo
  def bar
    @a = "zzz"
  end
end
</publify:code>
                    ), [:macropre, :macropost])).to eq(%(
<div class=\"CodeRay\"><pre><notextile><span class=\"CodeRay\"><span class=\"keyword\">class</span> <span class=\"class\">Foo</span>
  <span class=\"keyword\">def</span> <span class=\"function\">bar</span>
    <span class=\"instance-variable\">@a</span> = <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">zzz</span><span class=\"delimiter\">&quot;</span></span>
  <span class=\"keyword\">end</span>
<span class=\"keyword\">end</span></span></notextile></pre></div>
                    ))
        end
      end # multiline
    end # code textfilter

    it 'test_code_plus_markup_chain' do
      build_stubbed :textile
      build_stubbed :markdown

      text = <<-EOF
*header text here*

<publify:code lang="ruby">
class test
  def method
    "foo"
  end
end
</publify:code>

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

    context 'lightbox' do
      it 'should work' do
        assert_equal "<a href=\"//photos23.flickr.com/31366117_b1a791d68e_b.jpg\" data-toggle=\"lightbox\" title=\"Matz\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_t.jpg\" width=\"67\" height=\"100\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:67px\">This is Matz, Ruby's creator</p>",
                     filter_text('<publify:lightbox img="31366117" thumbsize="Thumbnail" displaysize="Large" style="float:left"/>',
                                 [:macropre, :macropost],
                                 {})
      end

      it 'shoudl use default thumb image size' do
        assert_equal "<a href=\"//photos23.flickr.com/31366117_b1a791d68e_b.jpg\" data-toggle=\"lightbox\" title=\"Matz\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p>",
                     filter_text('<publify:lightbox img="31366117" displaysize="Large"/>',
                                 [:macropre, :macropost],
                                 {})
      end

      it 'should use default display image size' do
        assert_equal "<a href=\"//photos23.flickr.com/31366117_b1a791d68e_o.jpg\" data-toggle=\"lightbox\" title=\"Matz\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p>",
                     filter_text('<publify:lightbox img="31366117"/>',
                                 [:macropre, :macropost],
                                 {})
      end

      it 'should work with caption' do
        assert_equal "<a href=\"//photos23.flickr.com/31366117_b1a791d68e_o.jpg\" data-toggle=\"lightbox\" title=\"Matz\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a>",
                     filter_text('<publify:lightbox img="31366117" caption=""/>',
                                 [:macropre, :macropost],
                                 {})
      end
    end

    describe 'combining a post-macro' do
      describe 'with markdown' do
        it 'correctly interprets the macro' do
          result = filter_text('<publify:flickr img="31366117" size="Square" style="float:left"/>',
                               [:macropre, :markdown, :macropost])
          expect(result).to match(%r{<div style="float:left" class="flickrplugin"><a href="http://www.flickr.com/users/scottlaird/31366117"><img src="//photos23.flickr.com/31366117_b1a791d68e_s.jpg" width="75" height="75" alt="Matz" title="Matz"/></a><p class="caption" style="width:75px">This is Matz, Ruby's creator</p></div>})
        end
      end

      describe 'with markdown' do
        it 'correctly interprets the macro' do
          result = filter_text('<publify:flickr img="31366117" size="Square" style="float:left"/>',
                               [:macropre, :textile, :macropost])
          expect(result).to eq("<div style=\"float:left\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"//photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>")
        end
      end
    end
  end # #filter_text

  it '#filter text by name' do
    build_stubbed('markdown smartypants')
    result = TextFilter.filter_text_by_name(blog, '*"foo"*', 'markdown smartypants')
    expect(result).to eq('<p><em>&#8220;foo&#8221;</em></p>')
  end
end
