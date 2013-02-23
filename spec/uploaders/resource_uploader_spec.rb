require 'spec_helper'

describe ResourceUploader do
  describe ".versions" do
    it "has two versions" do
      ResourceUploader.versions.keys.should include(:thumb, :medium)
    end
  end
end
