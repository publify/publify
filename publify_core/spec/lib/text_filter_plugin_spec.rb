# frozen_string_literal: true

require 'rails_helper'

describe TextFilterPlugin::Macro do
  describe '#self.attributes_parse' do
    it 'parses lang="ruby" to {"lang" => "ruby"}' do
      expect(described_class.attributes_parse('<publify:code lang="ruby">')).to eq('lang' => 'ruby')
    end

    it "parses lang='ruby' to {'lang' => 'ruby'}" do
      expect(described_class.attributes_parse("<publify:code lang='ruby'>")).to eq('lang' => 'ruby')
    end
  end
end
