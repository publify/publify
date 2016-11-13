require 'rails_helper'

describe TextFilterPlugin::Macro do
  describe '#self.attributes_parse' do
    it 'should parse lang="ruby" to {"lang" => "ruby"}' do
      expect(TextFilterPlugin::Macro.attributes_parse('<publify:code lang="ruby">')).to eq('lang' => 'ruby')
    end

    it "should parse lang='ruby' to {'lang' => 'ruby'}" do
      expect(TextFilterPlugin::Macro.attributes_parse("<publify:code lang='ruby'>")).to eq('lang' => 'ruby')
    end
  end
end
