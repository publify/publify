require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  helper_name 'application'
  
  describe '#render_flash' do
    it 'should render empty string if no flash' do
      render_flash.should == ''
    end

    it 'should render a good render if only one notice' do
      flash[:notice] = 'good update'
      render_flash.should == '<span class="notice">good update</span>'
    end

    it 'should render the notice and error flash' do
      flash[:notice] = 'good update'
      flash[:error] = "it's not good"
      render_flash.split("<br />\n").sort.should == ['<span class="error">it\'s not good</span>','<span class="notice">good update</span>']

    end

  end
end
