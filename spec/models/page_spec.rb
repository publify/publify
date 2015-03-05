# coding: utf-8
require 'rails_helper'

describe Page, type: :model do
  let!(:blog) { create(:blog) }

  describe 'name=' do
    context 'when build a page without name' do
      let(:page) { create(:page, name: nil, title: 'A title') }
      it { expect(page.name).to eq('a-title') }
    end
  end

  describe 'permalink' do
    context 'with an existing page' do
      before(:each) { Rails.cache.clear }
      let(:page) { create(:page, name: 'page_one') }
      it { expect(page.permalink_url).to eq('http://myblog.net/pages/page_one') }
    end
  end

  describe 'validations' do
    context 'with an existing page name' do
      let!(:page) { create(:page, name: 'page_one') }
      it { expect(build(:page, name: page.name)).to be_invalid }
    end

    context 'without name' do
      it { expect(build(:page, name: nil)).to be_valid }
    end

    context 'without body' do
      it { expect(build(:page, body: nil)).to be_invalid }
    end

    context 'without title' do
      it { expect(build(:page, title: nil)).to be_invalid }
    end
  end

  describe 'default_text_filter' do
    it { expect(create(:page).default_text_filter.name).to eq(blog.text_filter) }
  end

  describe 'search_with' do
    context 'with an simple page' do
      let!(:page) { create(:page) }

      subject { Page.search_with(params) }

      context 'with nil params' do
        let(:params) { nil }
        it { expect(subject).to eq([page]) }
      end

      context 'with a matching searchstring page' do
        let(:params) { { searchstring: 'foobar' } }
        let!(:match_page) { create(:page, title: 'foobar') }
        it { expect(subject).to eq([match_page]) }
      end

      context 'with 2 pages with title aaa and zzz' do
        let!(:last_page) { create(:page, title: 'ZZZ', published: true) }
        let!(:first_page) { create(:page, title: 'AAA', published: true) }
        let(:params) { { published: '1' } }
        it { expect(subject).to eq([first_page, page, last_page]) }
      end
    end
  end

  describe 'redirects' do
    context 'with a simple page' do
      let(:page) { create(:page) }
      it { expect(page.redirects.first.to_path).to eq(page.permalink_url) }
    end

    context 'with an unpublished page' do
      let(:page) { create(:page, published: false) }
      it { expect(page.redirects).to be_empty }
    end
  end
end
