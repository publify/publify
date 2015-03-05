require 'rails_helper'

describe ResourceUploader do
  describe '.versions' do
    it 'has two versions' do
      expect(ResourceUploader.versions.keys).to include(:thumb, :medium)
    end
  end
end
