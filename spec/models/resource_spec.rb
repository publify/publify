require 'spec_helper'

describe Resource, ' with its fixtures loaded' do
  it 'fullpath should be ::Rails.root.to_s + "/public/files/" + resource.filename' do
    res = Factory(:resource, :filename => 'a_new_file')
    res.fullpath.should == ::Rails.root.to_s + "/public/files/a_new_file"
  end

  it 'resources created with the same name as an existing resource don\'t overwrite the old resource' do
    File.stub!(:exist?).and_return(true)
    File.should_receive(:exist?).with(%r{public/files/me\.jpg$}).and_return(true)
    File.should_receive(:exist?).with(%r{public/files/me1\.jpg$}).at_least(:once).and_return(false)

    f1 = Factory(:resource, :filename => 'me.jpg')
    f1.should be_valid
    f1.filename.should == 'me1.jpg'
  end

  it 'a resource deletes its associated file on destruction' do
    File.should_receive(:exist?).and_return(false)
    res = Factory(:resource, :filename => 'file_name')

    File.should_receive(:exist?).with(res.fullpath).and_return(true)
    File.should_receive(:unlink).with(res.fullpath).and_return(true)
    res.destroy
  end
end
