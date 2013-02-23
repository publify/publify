require 'spec_helper'

def file_upload(filename)
  ActionDispatch::Http::UploadedFile.new(
    :tempfile => File.new(Rails.root.join("spec", "fixtures", "testfile.txt")),
    :filename => filename)
end

describe Resource do
  describe "scopes" do
    describe "#without_images" do
      it "should list resource that are not image (based on mime type)" do
        other_resource = FactoryGirl.create(:resource, :mime => 'text/css')
        image_resource = FactoryGirl.create(:resource, :mime => 'image/jpeg')
        Resource.without_images.should == [other_resource]
      end
    end

    describe "#images" do
      it "should list only images (based on mime type)" do
        other_resource = FactoryGirl.create(:resource, :mime => 'text/css')
        image_resource = FactoryGirl.create(:resource, :mime => 'image/jpeg')
        Resource.images.should == [image_resource]
      end

    end

    describe "#by_filename" do
      it "should sort resource by filename" do
        b_resource = FactoryGirl.create(:resource, upload: file_upload("b"))
        a_resource = FactoryGirl.create(:resource, upload: file_upload("a"))
        Resource.by_filename.should == [a_resource, b_resource]
      end
    end

    describe "#by_created_at" do
      it "should sort resource by created_at DESC" do
        b_resource = FactoryGirl.create(:resource, :created_at => DateTime.new(2011,03,13))
        a_resource = FactoryGirl.create(:resource, :created_at => DateTime.new(2011,02,21))
        Resource.by_created_at.should == [b_resource, a_resource]
      end
    end

     describe "#without_images_by_filename" do
      it "should combine 2 scopes" do
        image_resource = FactoryGirl.create(:resource, :mime => 'image/jpeg')
        b_resource = FactoryGirl.create(:resource, mime: 'text/html', upload: file_upload("b"))
        a_resource = FactoryGirl.create(:resource, mime: 'text/html', upload: file_upload("a"))
        Resource.without_images_by_filename.should == [a_resource, b_resource]
      end
    end


  end
end
