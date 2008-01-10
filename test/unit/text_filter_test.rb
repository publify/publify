require File.dirname(__FILE__) + '/../test_helper'

require 'flickr_mock'

class TextFilterTest < Test::Unit::TestCase
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

    assert filters.include?(Typo::Textfilter::Markdown)
    assert filters.include?(Typo::Textfilter::Smartypants)
    assert filters.include?(Typo::Textfilter::Htmlfilter)
    assert filters.include?(Typo::Textfilter::Textile)
    assert filters.include?(Typo::Textfilter::Amazon)
    assert filters.include?(Typo::Textfilter::Flickr)

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

    assert types['markup'].include?(Typo::Textfilter::Markdown)
    assert types['markup'].include?(Typo::Textfilter::Textile)

    assert types['macropost'].include?(Typo::Textfilter::Flickr)

    assert types['macropre'].include?(Typo::Textfilter::Code)

    assert types['postprocess'].include?(Typo::Textfilter::Smartypants)
    assert types['postprocess'].include?(Typo::Textfilter::Amazon)

    assert types['other'].include?(Typo::Textfilter::Htmlfilter)
    assert types['other'].include?(Typo::Textfilter::MacroPre)
    assert types['other'].include?(Typo::Textfilter::MacroPost)

    # There shouldn't be any 'other' plugins coming from users; they
    # should all be part of the core
    assert_equal 3, types['other'].size
  end

  def test_map
    map = TextFilter.filters_map

    assert_equal Typo::Textfilter::Markdown,
          map['markdown']
    assert_equal Typo::Textfilter::Smartypants,
          map['smartypants']
    assert_equal Typo::Textfilter::Htmlfilter,
          map['htmlfilter']
    assert_equal Typo::Textfilter::Textile,
          map['textile']
    assert_equal Typo::Textfilter::Amazon,
          map['amazon']
    assert_equal Typo::Textfilter::Flickr,
          map['flickr']
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
