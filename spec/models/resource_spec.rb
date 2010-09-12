require File.dirname(__FILE__) + '/../spec_helper'

describe Resource, ' with its fixtures loaded' do
  before(:each) do
    File.stub!(:exist?).and_return(true)
  end

  it 'fullpath should be ::Rails.root.to_s + "/public/files/" + resource.filename' do
    res = Resource.new(:article_id => 1, :filename => 'a_new_file', :mime => 'image/jpeg', :size => 110)
    res.fullpath.should == ::Rails.root.to_s + "/public/files/a_new_file"
  end

  it 'resources created with the same name as an existing resource don\'t overwrite the old resource' do
    File.should_receive(:exist?).with(%r{public/files/me\.jpg$}).and_return(true)
    File.should_receive(:exist?).with(%r{public/files/me1\.jpg$}).at_least(:once).and_return(false)
    File.should_receive(:unlink).with(%r{public/files/me1\.jpg$}).and_return(true)

    f1 = Resource.create(:filename => 'me.jpg',
                         :mime => 'image/jpeg')
    f1.should_not be_nil
    f1.should be_valid

    f1.filename.should_not == 'me.jpg'
    f1.filename.should == 'me1.jpg'
    f1.destroy
  end

  it 'a resource deletes its associated file on destruction' do
    File.should_receive(:exist?).and_return(false)
    res = Factory(:resource, :filename => 'file_name')

    File.should_receive(:exist?).with(res.fullpath).and_return(true)
    File.should_receive(:unlink).with(res.fullpath).and_return(true)
    res.destroy
  end
end
