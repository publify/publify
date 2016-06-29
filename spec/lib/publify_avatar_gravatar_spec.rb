require 'rails_helper'

describe PublifyPlugins::Gravatar do
  describe '.get_avatar' do
    let(:gravatar_tag) { described_class.get_avatar }

    it 'returns an html safe string' do
      expect(gravatar_tag).to be_html_safe
    end
  end
end
