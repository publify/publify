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

  describe '#available_filters' do
    subject { TextFilterPlugin.available_filters }
    it { is_expected.to include(PublifyApp::Textfilter::Markdown) }
    it { is_expected.to include(PublifyApp::Textfilter::Smartypants) }
    it { is_expected.to include(PublifyApp::Textfilter::Htmlfilter) }
    it { is_expected.to include(PublifyApp::Textfilter::Textile) }
    it { is_expected.to include(PublifyApp::Textfilter::Flickr) }
    it { is_expected.to include(PublifyApp::Textfilter::Code) }
    it { is_expected.to include(PublifyApp::Textfilter::Lightbox) }
    it { is_expected.to include(PublifyApp::Textfilter::Twitterfilter) }
    it { is_expected.not_to include(TextFilterPlugin::Markup) }
    it { is_expected.not_to include(TextFilterPlugin::Macro) }
  end

  describe '#macro_filters' do
    subject { TextFilterPlugin.macro_filters }
    it { is_expected.not_to include(PublifyApp::Textfilter::Markdown) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Smartypants) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Htmlfilter) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Textile) }
    it { is_expected.to include(PublifyApp::Textfilter::Flickr) }
    it { is_expected.to include(PublifyApp::Textfilter::Code) }
    it { is_expected.to include(PublifyApp::Textfilter::Lightbox) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Twitterfilter) }
    it { is_expected.not_to include(TextFilterPlugin::Markup) }
    it { is_expected.not_to include(TextFilterPlugin::Macro) }
  end
end
