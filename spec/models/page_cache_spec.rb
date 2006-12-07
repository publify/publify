require File.dirname(__FILE__) + '/../spec_helper'
require 'page_cache'

class PageCache
  cattr_accessor :mock_file_deleter
  def delete_file(path)
    PageCache.mock_file_deleter.delete_file(path)
  end
end

context 'With the fixtures loaded' do
  fixtures :page_caches

  setup do
    @deleter = mock('fdeleter')
    PageCache.mock_file_deleter = @deleter
  end

  specify '#sweep_all catches_all the pages' do
    @deleter.should_receive(:delete_file).once.with(%r{/index\.html$})
    @deleter.should_receive(:delete_file).once.with(%r{/articles/2005/05/05/title$})

    PageCache.count.should == 2
    PageCache.sweep_all
    PageCache.count.should == 0
  end

  specify '#sweep_by_pattern does the right thing' do
    @deleter.should_receive(:delete_file).once.with(%r{/articles/2005/05/05/title$})

    PageCache.count.should == 2
    PageCache.sweep('articles%')
    PageCache.count.should == 1
  end
end
