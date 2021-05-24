# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextFilterPlugin do
  describe ".available_filters" do
    subject { described_class.available_filters }

    it { is_expected.to include(PublifyApp::Textfilter::Markdown) }
    it { is_expected.to include(PublifyApp::Textfilter::Smartypants) }
    it { is_expected.to include(PublifyApp::Textfilter::Htmlfilter) }
    it { is_expected.to include(PublifyApp::Textfilter::Flickr) }
    it { is_expected.to include(PublifyApp::Textfilter::Code) }
    it { is_expected.to include(PublifyApp::Textfilter::Lightbox) }
    it { is_expected.to include(PublifyApp::Textfilter::Twitterfilter) }
    it { is_expected.not_to include(TextFilterPlugin::Markup) }
    it { is_expected.not_to include(TextFilterPlugin::Macro) }
    it { is_expected.not_to include(TextFilterPlugin::MacroPre) }
    it { is_expected.not_to include(TextFilterPlugin::MacroPost) }
  end

  describe ".macro_filters" do
    subject { described_class.macro_filters }

    it { is_expected.not_to include(PublifyApp::Textfilter::Markdown) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Smartypants) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Htmlfilter) }
    it { is_expected.to include(PublifyApp::Textfilter::Flickr) }
    it { is_expected.to include(PublifyApp::Textfilter::Code) }
    it { is_expected.to include(PublifyApp::Textfilter::Lightbox) }
    it { is_expected.not_to include(PublifyApp::Textfilter::Twitterfilter) }
    it { is_expected.not_to include(TextFilterPlugin::Markup) }
    it { is_expected.not_to include(TextFilterPlugin::Macro) }
    it { is_expected.not_to include(TextFilterPlugin::MacroPre) }
    it { is_expected.not_to include(TextFilterPlugin::MacroPost) }
  end
end
