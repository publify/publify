# frozen_string_literal: true

require "rails_helper"

describe Note, type: :model do
  context "with a simple blog" do
    let!(:blog) { create(:blog) }

    describe "validations" do
      it { expect(build(:note)).to be_valid }
      it { expect(build(:note).redirect).to be_blank }
      it { expect(create(:note).redirect).not_to be_blank }
      it { expect(build(:note, body: nil)).to be_invalid }

      it "with a nil body, return default error message" do
        note = build(:note, body: nil)
        note.save
        expect(note.errors[:body]).to eq(["can't be blank"])
      end

      context "with an existing note" do
        let(:existing_note) { create(:note) }

        it { expect(build(:note, guid: existing_note.guid)).to be_invalid }
      end
    end

    describe "permalink" do
      let(:note) do
        Rails.cache.clear
        create(:note, body: "àé")
      end

      it { expect(note.permalink).to eq("#{note.id}-ae") }
      it { expect(note.permalink_url).to eq("#{blog.base_url}/note/#{note.id}-ae") }

      context "with a particular blog" do
        before do
          allow_any_instance_of(Blog).
            to receive(:custom_url_shortener).and_return(url_shortener)
          allow_any_instance_of(Blog).
            to receive(:base_url).and_return("http://mybaseurl.net")
        end

        context "with a blog that have a custome url shortener" do
          let(:url_shortener) { "shor.tl" }

          it {
            expect(note.short_link).
              to eq("#{url_shortener} #{note.redirect.from_path}")
          }
        end

        context "with a blog that does not have a custome url shortener" do
          let(:url_shortener) { nil }

          it { expect(note.short_link).to eq("mybaseurl.net #{note.redirect.from_path}") }
        end
      end
    end

    describe "#redirect" do
      let(:note) { create(:note) }

      it { expect(note.redirect.to_path).to eq note.permalink_url }
    end

    describe "scopes" do
      describe "#published" do
        let(:note) { create(:note, published_at: 1.minute.ago) }

        context "with a unpublished note" do
          let!(:unpublished_note) { create(:unpublished_note) }

          it { expect(described_class.published).to eq([note]) }
        end

        context "with a note to publish later" do
          let!(:later_note) { create(:note, published_at: 3.days.from_now) }

          it { expect(described_class.published).to eq([note]) }
        end
      end
    end

    describe "send_to_twitter" do
      context "with a simple note" do
        let(:note) { build(:note) }

        context "with twitter configured for blog and user" do
          before do
            expect_any_instance_of(Blog).
              to receive(:has_twitter_configured?).and_return(true)
            expect_any_instance_of(User).
              to receive(:has_twitter_configured?).and_return(true)
          end

          it { expect(note.send_to_twitter).to be_falsey }
        end

        context "with twitter not configured for blog" do
          before do
            expect_any_instance_of(Blog).
              to receive(:has_twitter_configured?).and_return(false)
          end

          it { expect(note.send_to_twitter).to be_falsey }
        end

        context "with a twitter configured for blog but not user" do
          before do
            expect_any_instance_of(Blog).
              to receive(:has_twitter_configured?).and_return(true)
            expect_any_instance_of(User).
              to receive(:has_twitter_configured?).and_return(false)
          end

          it { expect(note.send_to_twitter).to be_falsey }
        end
      end

      context "with a more than 140 char note" do
        let(:note) do
          create :note, body: <<~TXT
            A big message that contains more than 140 char is not too
            hard to do. You only need to speak as a french guy, a lot to
            say nothing. And that is  probably the best way to write more
            than 140 char.
          TXT
        end

        let(:fake_twitter) { double(Twitter::REST::Client) }

        before do
          expect(Twitter::REST::Client).to receive(:new).and_return(fake_twitter)
          expect(fake_twitter).
            to receive(:update).
            and_raise(Twitter::Error::Forbidden.new("Status is over 140 characters."))
          expect_any_instance_of(Blog).to receive(:has_twitter_configured?).and_return(true)
          expect_any_instance_of(User).to receive(:has_twitter_configured?).and_return(true)
          note.send_to_twitter
        end

        it {
          expect(note.errors.full_messages).
            to eq(["Message Status is over 140 characters."])
        }
      end
    end

    describe "twitter_url" do
      let(:user) { build(:user, twitter: "@hello") }
      let(:note) { build(:note, user: user, settings: { twitter_id: "12345678901234" }) }

      it {
        expect(note.twitter_url).
          to eq("https://twitter.com/#{note.user.twitter}/status/#{note.twitter_id}")
      }
    end

    describe "default_text_filter" do
      let(:note) { build(:note) }

      it { expect(note.default_text_filter.name).to eq(note.blog.text_filter) }
    end

    describe "twitter_message" do
      let(:blog) { create :blog, base_url: "http://myblog.net" }
      let(:note) { create(:note, blog: blog, body: tweet) }

      context "with a short simple message" do
        let(:tweet) { "A message without URL" }

        it { expect(note.twitter_message).to start_with(tweet) }
        it { expect(note.twitter_message).to end_with(" (#{note.short_link})") }
      end

      context "with a short message with short HTTP url" do
        let(:tweet) { "A message with a short URL http://foo.com" }

        it { expect(note.twitter_message).to eq("#{tweet} (#{note.short_link})") }
      end

      context "with a short message much more than 114 char" do
        let(:tweet) do
          "A very big(10) message with lot of text (40)inside just to try the" \
          " shortener and (80)the new link that publify must create and add at the end"
        end
        let(:expected_tweet) do
          "A very big(10) message with lot of text (40)inside just to try the" \
          " shortener and (80)the new link that publify... (#{note.redirect.from_url})"
        end

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(140) }
      end

      context "With a test message from production..." do
        let(:tweet) do
          "Le dojo de nantes, c'est comme au McDo, sans les odeurs, et en plus rigolo:" \
            " RT @abailly Ce midi c'est coding dojo à la Cantine #Nantes." \
            " Pour s'inscrire si vous voulez c'est ici:" \
            " http://cantine.atlantic2.org/evenements/coding-dojo-8/ …" \
            " Sinon venez comme vous êtes"
        end
        let(:expected_tweet) do
          "Le dojo de nantes, c'est comme au McDo, sans les odeurs, et en plus rigolo:" \
          " RT @abailly Ce midi c'est coding... (#{note.redirect.from_url})"
        end

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(138) }
      end

      context "with a bug message" do
        let(:tweet) do
          '"JSFuck is an esoteric and educational programming style based on the' \
          " atomic parts of JavaScript. It uses only six different characters to" \
          ' write and execute code." http://www.jsfuck.com/ '
        end
        let(:expected_tweet) do
          "\"JSFuck is an esoteric and educational programming style based on the" \
          " atomic parts of JavaScript. It uses only... (#{note.redirect.from_url})"
        end

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(140) }
      end

      context "don't cut word" do
        let(:tweet) do
          "Le #mobprogramming c'est un peu comme faire un dojo sur une journée entière" \
          " (ça permet sûrement de faire des petites journées ;-))"
        end
        let(:expected_tweet) do
          "Le #mobprogramming c'est un peu comme faire un dojo sur une journée entière" \
          " (ça permet sûrement de faire des... (#{note.redirect.from_url})"
        end

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(138) }
      end

      context "shortener host name is counted as an url by twitter" do
        let(:tweet) do
          "RT @stephaneducasse http://pharocloud.com is so cool. I love love such idea" \
          " and I wish them success. Excellent work."
        end
        let(:expected_tweet) do
          "RT @stephaneducasse http://pharocloud.com is so cool. I love love such idea" \
          " and I wish them success. Excellent... (#{note.redirect.from_url})"
        end

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(140) }
      end
    end

    describe "#html" do
      it "returns an html_safe string" do
        note = build(:note, body: "A test tweet with a #hashtag")
        expect(note.html).to be_html_safe
      end
    end
  end

  context "with a dofollowify blog" do
    let!(:blog) { create(:blog, dofollowify: true) }

    describe "Testing hashtag and @mention replacement in html postprocessing" do
      it "replaces a hashtag with a proper URL to Twitter search" do
        note = build(:note, body: "A test tweet with a #hashtag")
        expected =
          "A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&" \
          "src=tren&mode=realtime'>#hashtag</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end

      it "replaces a @mention by a proper URL to the twitter account" do
        note = create(:note, body: "A test tweet with a @mention")
        expected = "A test tweet with a <a href='https://twitter.com/mention'>@mention</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end

      it "replaces a http URL by a proper link" do
        note = create(:note, body: "A test tweet with a http://link.com")
        expected = "A test tweet with a <a href='http://link.com'>http://link.com</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end

      it "replaces a https URL with a proper link" do
        note = create(:note, body: "A test tweet with a https://link.com")
        expected = "A test tweet with a <a href='https://link.com'>https://link.com</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end
    end
  end
end
