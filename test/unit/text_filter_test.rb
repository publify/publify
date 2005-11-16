require File.dirname(__FILE__) + '/../test_helper'

require 'flickr_mock'
require 'application'

class TextFilterTest < Test::Unit::TestCase
  fixtures :text_filters

  def setup
    @text_filter = TextFilter.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TextFilter,  @text_filter
  end

  def test_markdownsmartypants_fixture
    ms = TextFilter.find_by_name('markdown smartypants')

    assert_equal text_filters(:markdownsmartypants_filter), ms
    assert_equal 'markdown', ms.markup
    assert_equal [:smartypants], ms.filters
    assert_equal Hash.new, ms.params
  end

  def test_textile_fixture
    tx = TextFilter.find_by_name('textile')
    assert_equal text_filters(:textile_filter), tx
    assert_equal 'textile', tx.markup
    assert_equal [], tx.filters
  end

  def test_available
    filters = TextFilter.available_filters

    assert filters.include?(Textfilters::MarkdownController)
    assert filters.include?(Textfilters::SmartypantsController)
    assert filters.include?(Textfilters::HtmlfilterController)
    assert filters.include?(Textfilters::TextileController)
    assert filters.include?(Textfilters::AmazonController)
    assert filters.include?(Textfilters::FlickrController)

    assert !filters.include?(TextFilterPlugin::Markup)
    assert !filters.include?(TextFilterPlugin::Macro)
    assert !filters.include?(TextFilterPlugin::PostProcess)
  end
  
  def test_descriptions
    TextFilter.available_filters.each do |filter|
      assert filter.display_name.to_s.size > 0, "Blank display name for #{filter}"
      assert filter.description.to_s.size > 0, "Blank description for #{filter}"
      assert_not_equal 'Unknown Text Filter ',filter.display_name
      assert_not_equal 'Unknown Text Filter Description',filter.description
    end
  end

  def test_filtertypes
    types = TextFilter.available_filter_types

    assert_kind_of Hash, types

    assert types['markup']
    assert types['macropre']
    assert types['macropost']
    assert types['postprocess']
    assert types['other']

    assert types['markup'].include?(Textfilters::MarkdownController)
    assert types['markup'].include?(Textfilters::TextileController)

    assert types['macropost'].include?(Textfilters::FlickrController)

    assert types['macropre'].include?(Textfilters::CodeController)

    assert types['postprocess'].include?(Textfilters::SmartypantsController)
    assert types['postprocess'].include?(Textfilters::AmazonController)

    assert types['other'].include?(Textfilters::HtmlfilterController)
    assert types['other'].include?(Textfilters::MacroPreController)
    assert types['other'].include?(Textfilters::MacroPostController)

    # There shouldn't be any 'other' plugins coming from users; they
    # should all be part of the core 
    assert_equal 3, types['other'].size
  end
  
  def test_map
    map = TextFilter.filters_map

    assert_equal Textfilters::MarkdownController, map['markdown']
    assert_equal Textfilters::SmartypantsController, map['smartypants']
    assert_equal Textfilters::HtmlfilterController, map['htmlfilter']
    assert_equal Textfilters::TextileController, map['textile']
    assert_equal Textfilters::AmazonController, map['amazon']
    assert_equal Textfilters::FlickrController, map['flickr']
  end

  def test_help
    filter = TextFilter.find_by_name('markdown')
    help = filter.help.to_s

    assert help
    assert help.size > 100
    assert help =~ /Flickr/
    assert help =~ /Markdown/
    assert help =~ /daringfireball/
    assert help =~ /<em>/
  end
  
  def test_commenthelp
    filter = TextFilter.find_by_name('markdown')
    help = filter.commenthelp.to_s
    
    assert help
    assert help.size>100
    assert help !~ /Flickr/
    assert help !~ /<h.>/
    assert help =~ /<em>/
  end
end
