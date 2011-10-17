require 'spec_helper'

describe Resource do
  describe '#fullpath' do
    it 'should be ::Rails.root.to_s + "/public/files/" + resource.filename' do
      res = Factory(:resource, :filename => 'a_new_file')
      res.fullpath.should == ::Rails.root.to_s + "/public/files/a_new_file"
    end
  end

  describe "scopes" do
    describe "#without_images" do
      it "should list resource that are not image (based on mime type)" do
        other_resource = Factory(:resource, :mime => 'text/css')
        image_resource = Factory(:resource, :mime => 'image/jpeg')
        Resource.without_images.should == [other_resource]
      end
    end

    describe "#images" do
      it "should list only images (based on mime type)" do
        other_resource = Factory(:resource, :mime => 'text/css')
        image_resource = Factory(:resource, :mime => 'image/jpeg')
        Resource.images.should == [image_resource]
      end

    end

    describe "#by_filename" do
      it "should sort resource by filename" do
        b_resource = Factory(:resource, :filename => 'b')
        a_resource = Factory(:resource, :filename => 'a')
        Resource.by_filename.should == [a_resource, b_resource]
      end
    end

    describe "#by_created_at" do
      it "should sort resource by created_at DESC" do
        b_resource = Factory(:resource, :created_at => DateTime.new(2011,03,13))
        a_resource = Factory(:resource, :created_at => DateTime.new(2011,02,21))
        Resource.by_created_at.should == [b_resource, a_resource]
      end
    end

     describe "#without_images_by_filename" do
      it "should combine 2 scopes" do
        image_resource = Factory(:resource, :mime => 'image/jpeg')
        b_resource = Factory(:resource, :mime => 'text/html', :filename => 'b')
        a_resource = Factory(:resource, :mime => 'text/html', :filename => 'a')
        Resource.without_images_by_filename.should == [a_resource, b_resource]
      end
    end


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
