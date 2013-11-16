# coding: utf-8
require 'spec_helper'

describe Note do
  context "with a simple blog" do
    let!(:blog) { create(:blog) }

    describe "validations" do
      it { expect(build(:note)).to be_valid }
      it { expect(build(:note, body:nil)).to be_invalid }

      it "with a nil body, return default error message" do
        note = build(:note, body:nil)
        note.save
        expect(note.errors[:body]).to eq(["can't be blank"])
      end

      context "with an existing note" do
        let(:existing_note) { create(:note) }
        it { expect(build(:note, guid: existing_note.guid)).to be_invalid }
      end
    end

    describe :permalink do
      let(:note) { create(:note, body:"àé") }

      it { expect(note.permalink).to eq("#{note.id}-ae") }
      it { expect(note.permalink_url).to eq("#{blog.base_url}/note/#{note.id}-ae") }

      context "with a particular blog" do
        before(:each) do
          Blog.any_instance.stub(:custom_url_shortener).and_return(url_shortener)
          Blog.any_instance.stub(:base_url).and_return("http://mybaseurl.net")
        end

        context "with a blog that have a custome url shortener" do
          let(:url_shortener) { "shor.tl" }
          it { expect(note.short_link).to eq("#{url_shortener} #{note.redirects.first.from_path}") }
        end

        context "with a blog that have a custome url shortener" do
          let(:url_shortener) { nil }
          it { expect(note.short_link).to eq("mybaseurl.net #{note.redirects.first.from_path}") }
        end
      end
    end

    describe :redirects do
      let(:note) { create(:note) }
      it { expect(note.redirects.map(&:to_path)).to eq([note.permalink_url]) }
    end

    describe :scopes do

      describe :published do
        let(:now) { DateTime.new(2012,5,20,14,23) }
        let(:note) { create(:note, published_at: now - 1.minute) }

        before(:each) { Time.stub(:now).and_return(now) }

        context "with a unpubilshed note" do
          let(:unpublished_note) { create(:unpublished_note) }
          it { expect(Note.published).to eq([note]) }
        end

        context "with a note to publish later" do
          let(:later_note) { create(:note, published_at: now + 3.days) }
          it { expect(Note.published).to eq([note]) }
        end
      end
    end

    describe :send_to_twitter do
      let(:note) { build(:note) }
      context "with twitter configured for blog and user" do
        before(:each) do
          Blog.any_instance.should_receive(:has_twitter_configured?).and_return(true)
          User.any_instance.should_receive(:has_twitter_configured?).and_return(true)
        end

        it { expect(note.send_to_twitter).to be_false }
      end

      context "with twitter not configured for blog" do
        before(:each) do
          Blog.any_instance.should_receive(:has_twitter_configured?).and_return(false)
        end
        it { expect(note.send_to_twitter).to be_false }
      end

      context "with a twitter configured for blog but not user" do
        before(:each) do
          Blog.any_instance.should_receive(:has_twitter_configured?).and_return(true)
          User.any_instance.should_receive(:has_twitter_configured?).and_return(false)
        end
        it { expect(note.send_to_twitter).to be_false }
      end

    end

    describe :default_text_filter do
      let(:note) { build(:note) }
      it { expect(note.default_text_filter.name).to eq(Blog.default.text_filter) }
    end

    describe :twitter_message do
      let(:note) { create(:note, body: tweet) }

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
        let(:tweet) { "A very big(10) message with lot of text (40)inside just to try the shortener and (80)the new link that publify must create and add at the end" }
        let(:expected_tweet) { "A very big(10) message with lot of text (40)inside just to try the shortener and (80)the new link that publify... (#{note.redirects.first.to_url})" }
        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(140) }
        it { expect(note.twitter_message).to end_with(" (#{note.redirects.first.to_url})") }
      end

      context "with a bug message" do
        let(:tweet) { "\"JSFuck is an esoteric and educational programming style based on the atomic parts of JavaScript. It uses only six different characters to write and execute code.\" http://www.jsfuck.com/ " }
        let(:expected_tweet) { "\"JSFuck is an esoteric and educational programming style based on the atomic parts of JavaScript. It uses only... (#{note.redirects.first.to_url})" }

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(140) }
        it { expect(note.twitter_message).to end_with(" (#{note.redirects.first.to_url})") }
      end

      context "don't cut word" do
        let(:tweet) { "Le #mobprogramming c'est un peu comme faire un dojo sur une journée entière (ça permet sûrement de faire des petites journées ;-))" }
        let(:expected_tweet) { "Le #mobprogramming c'est un peu comme faire un dojo sur une journée entière (ça permet sûrement de faire des... (#{note.redirects.first.to_url})" }

        it { expect(note.twitter_message).to eq(expected_tweet) }
        it { expect(note.twitter_message.length).to eq(138) }
        it { expect(note.twitter_message).to end_with(" (#{note.redirects.first.to_url})") }
      end

    end
  end

  context "with a dofollowify blog" do
    let!(:blog) { create(:blog, dofollowify: true) }

    describe "Testing hashtag and @mention replacement in html postprocessing" do
      it "should replace a hashtag with a proper URL to Twitter search" do
        note = build(:note, body: "A test tweet with a #hashtag")
        expected = "A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&src=tren&mode=realtime'>#hashtag</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end

      it "should replace a @mention by a proper URL to the twitter account" do
        note = create(:note, body: "A test tweet with a @mention")
        expected = "A test tweet with a <a href='https://twitter.com/mention'>@mention</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end

      it "should replace a http URL by a proper link" do
        note = create(:note, body: "A test tweet with a http://link.com")
        expected = "A test tweet with a <a href='http://link.com'>http://link.com</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end

      it "should replace a https URL with a proper link" do
        note = create(:note, body: "A test tweet with a https://link.com")
        expected = "A test tweet with a <a href='https://link.com'>https://link.com</a>"
        expect(note.html_preprocess(nil, note.body)).to eq(expected)
      end
    end
  end
end
