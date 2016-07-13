require 'rails_helper'

describe PublifyApp::Textfilter::Smartypants do
  describe '#filtertext' do
    it 'applies smartypants processing to the supplied text' do
      text = described_class.filtertext('"foo"')
      expect(text).to eq('&#8220;foo&#8221;')
    end
  end
end
