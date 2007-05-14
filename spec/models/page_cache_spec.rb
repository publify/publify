require File.dirname(__FILE__) + '/../spec_helper'
require 'page_cache'

describe PageCache, ' with the fixtures loaded' do
  fixtures :page_caches

  before do
    File.stub!(:delete).and_return(true)
    File.stub!(:file?).and_return(true)
  end

  it '#sweep_all catches_all the pages' do
    File.should_receive(:delete).once.with(%r{/index\.html$})
    File.should_receive(:delete).once.with(%r{/articles/2005/05/05/title$})

    PageCache.count.should == 2
    PageCache.sweep_all
    PageCache.count.should == 0
  end

  it '#sweep_by_pattern does the right thing' do
    File.should_receive(:delete).once.with(%r{/articles/2005/05/05/title$})

    PageCache.count.should == 2
    PageCache.sweep('articles%')
    PageCache.count.should == 1
  end
end
