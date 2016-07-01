require 'rails_helper'

describe ResourceUploader do
  describe '.versions' do
    it 'has three versions' do
      expect(ResourceUploader.versions.keys).to match_array [:thumb, :medium, :avatar]
    end
  end
end
