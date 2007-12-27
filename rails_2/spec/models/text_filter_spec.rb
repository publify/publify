require File.dirname(__FILE__) + '/../spec_helper'

describe "With the list of available filters" do
  before(:each) { @filters = TextFilter.available_filters }

  it 'Markdown is an available filter' do
    @filters.should include(Typo::Textfilter::Markdown)
  end

  it 'Smartypants is available' do
    @filters.should include(Typo::Textfilter::Smartypants)
  end

  it 'Htmlfilter is available' do
    @filters.should include(Typo::Textfilter::Htmlfilter)
  end

  it 'Textile is available' do
    @filters.should include(Typo::Textfilter::Textile)
  end

  it 'Amazon is available' do
    @filters.should include(Typo::Textfilter::Amazon)
  end

  it 'Flickr is available' do
    @filters.should include(Typo::Textfilter::Flickr)
  end

  it 'TextFilterPlugin::Markup should be unavailable' do
    @filters.should_not include(TextFilterPlugin::Markup)
  end

  it 'TextFilterPlugin::Macro should be unavailable' do
    @filters.should_not include(TextFilterPlugin::Macro)
  end

end
