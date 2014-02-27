require 'spec_helper'

describe AuthorsHelper do

  describe :display_profile_item do
    it 'should display the item as a list item if show_item is true' do
      item = display_profile_item('my@jabber.org', 'Jabber:')
      item.should have_selector('li', content: 'Jabber: my@jabber.org')
    end

    it 'should NOT display the item empty' do
      item = display_profile_item('', 'Jabber:')
      item.should be_nil
    end

    it 'should display a link if the item is an url' do
      item = display_profile_item('http://twitter.com/mytwitter', 'Twitter:')
      item.should have_selector('li') do
        have_selector('a', content: 'http://twitter.com/mytwitter')
      end
    end
  end

  describe :author_link do
    context "with an article" do
      let(:article) { build(:article, user: author) }

      context "with an author with a name to this article" do
        let(:author) { build(:user, name: "Henri") }

        context "with a link_to_author set in blog" do
          let!(:blog) { create(:blog, link_to_author: true) }
          it { expect(author_link(article)).to have_selector('a', href: "mailto:#{author.email}", content: author.name) }
        end

        context "with a no link_to_author set in blog" do
          let!(:blog) { create(:blog, link_to_author: false) }
          it { expect(author_link(article)).to eq(author.name) }
        end
      end

      context "with an author without a name to this article" do
        let(:author) { build(:user, name: "") }
        let(:article) { build(:article, author: author) }

        context "with a link_to_author set in blog" do
          let!(:blog) { create(:blog, link_to_author: true) }
          it { expect(author_link(article)).to eq(article.author) }
        end

        context "with a no link_to_author set in blog" do
          let!(:blog) { create(:blog, link_to_author: false) }
          it { expect(author_link(article)).to eq(article.author) }
        end
      end
    end
  end

end
