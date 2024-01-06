# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsController, type: :controller do
  render_views

  let(:blog) { create(:blog) }

  with_each_theme do |theme, _view_path|
    context "with theme #{theme}" do
      before do
        blog.theme = theme
        blog.save
      end

      describe "#index" do
        before do
          @tag = create(:tag)
          @tag.contents << create(:article)
        end

        it "lists tags" do
          get "index"
          expect(response.body).to have_content @tag.name
        end
      end

      describe "#show" do
        let(:parsed_body) { Capybara.string(response.body) }
        let(:article) { create(:article) }

        before do
          create(:tag, name: "foo", contents: [article])
          get "show", params: { id: "foo" }
        end

        it "has good rss feed link in head" do
          rss_link = parsed_body.
            find "head>link[href='http://test.host/tag/foo.rss']", visible: false
          aggregate_failures do
            expect(rss_link["rel"]).to eq "alternate"
            expect(rss_link["type"]).to eq "application/rss+xml"
            expect(rss_link["title"]).to eq "RSS"
          end
        end

        it "has good atom feed link in head" do
          atom_link = parsed_body.
            find "head>link[href='http://test.host/tag/foo.atom']", visible: false
          aggregate_failures do
            expect(atom_link["rel"]).to eq "alternate"
            expect(atom_link["type"]).to eq "application/atom+xml"
            expect(atom_link["title"]).to eq "Atom"
          end
        end

        it "has a canonical URL" do
          expect(response.body).
            to have_css("head>link[href='#{blog.base_url}/tag/foo']", visible: :all)
        end

        context "with a password protected article" do
          let(:article) { create(:article, password: "password") }

          it "article in tag should be password protected" do
            get "show", params: { id: "foo" }
            assert_select('input[id="article_password"]')
          end
        end
      end
    end
  end
end
