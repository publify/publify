require 'spec_helper'

describe ApplicationHelper do
  before(:each) { Factory(:blog) }
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

  describe "#link_to_permalink" do
    subject { link_to_permalink(Factory(:article), "bla") }
    it { should be_html_safe }
  end
end
