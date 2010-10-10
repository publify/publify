require 'spec_helper'

describe GroupingsHelper do
  describe '#ul_tag_for' do
    it 'returns plain ul by default' do
      ul_tag_for(nil).should == '<ul>'
    end
  end
end

