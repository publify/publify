# frozen_string_literal: true

require "rails_helper"

describe Page, type: :model do
  let!(:blog) { create(:blog) }

  describe "before save" do
    context "when saving a page without a name" do
      let(:page) { create(:page, name: nil, title: "A title") }

      it "sets the name based on the title" do
        expect(page.name).to eq("a-title")
      end
    end
  end

  describe "#permalink_url" do
    let(:page) { build(:page, name: "page_one", blog: blog) }

    it "returns a full url based on the page name in the pages section" do
      expect(page.permalink_url).to eq("#{blog.base_url}/pages/page_one")
    end
  end

  describe "validations" do
    context "with an existing page name" do
      let!(:page) { create(:page, name: "page_one") }

      it { expect(build(:page, name: page.name)).to be_invalid }
    end

    context "without name" do
      it { expect(build(:page, name: nil)).to be_valid }
    end

    context "without body" do
      it { expect(build(:page, body: nil)).to be_invalid }
    end

    context "without title" do
      it { expect(build(:page, title: nil)).to be_invalid }
    end
  end

  describe "default_text_filter" do
    it { expect(create(:page).default_text_filter.name).to eq(blog.text_filter) }
  end

  describe "search_with" do
    context "with an simple page" do
      subject { described_class.search_with(params) }

      let!(:page) { create(:page) }

      context "with nil params" do
        let(:params) { nil }

        it { expect(subject).to eq([page]) }
      end

      context "with a matching searchstring page" do
        let(:params) { { searchstring: "foobar" } }
        let!(:match_page) { create(:page, title: "foobar") }

        it { expect(subject).to eq([match_page]) }
      end

      context "with 2 pages with title aaa and zzz" do
        let!(:last_page) { create(:page, title: "ZZZ", state: "published") }
        let!(:first_page) { create(:page, title: "AAA", state: "published") }
        let(:params) { { published: "1" } }

        it { expect(subject).to eq([first_page, page, last_page]) }
      end
    end
  end

  describe "#redirect" do
    context "with a simple page" do
      let(:page) { create(:page) }

      it { expect(page.redirect.to_path).to eq(page.permalink_url) }
    end

    context "with an unpublished page" do
      let(:page) { create(:page, state: "draft") }

      it { expect(page.redirect).to be_blank }
    end
  end
end
