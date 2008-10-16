require File.dirname(__FILE__) + '/../spec_helper'

describe Resource, ' with its fixtures loaded' do
  before(:each) do
    File.stub!(:exist?).and_return(true)
  end

  it 'there are three resources in the database' do
    Resource.count.should == 3
  end

  it 'fullpath should be RAILS_ROOT + "/public/files/" + resource.filename' do
    res = Resource.new(:article_id => 1, :filename => 'a_new_file', :mime => 'image/jpeg', :size => 110)
    res.fullpath.should == RAILS_ROOT + "/public/files/a_new_file"
  end

  it 'resources created with the same name as an existing resource don\'t overwrite the old resource' do
    File.should_receive(:exist?).with(%r{public/files/me\.jpg$}).and_return(true)
    File.should_receive(:exist?).with(%r{public/files/me1\.jpg$}).at_least(:once).and_return(false)
    File.should_receive(:unlink).with(%r{public/files/me1\.jpg$}).and_return(true)

    f1 = Resource.create(:filename => resources(:resource1).filename,
                         :mime => resources(:resource1).mime)
    f1.should_not be_nil
    f1.should be_valid

    f1.filename.should_not == resources(:resource1).filename
    f1.filename.should == 'me1.jpg'
    f1.destroy
  end

  it 'a resource deletes its associated file on destruction' do
    res = resources(:resource1)
    File.should_receive(:exist?).with(res.fullpath).and_return(true)
    File.should_receive(:unlink).with(res.fullpath).and_return(true)

    res.destroy
  end
end
