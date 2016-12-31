require 'rails_helper'

RSpec.describe PingerJob, type: :job do
  describe '#perform' do
    context 'given a new article' do
      let(:blog) { create(:blog, send_outbound_pings: send_outbound_pings) }
      let(:article) { create :article, blog: blog }

      context 'given a blog that does not allow sending outbound pings' do
        let(:send_outbound_pings) { false }

        it 'does nothing' do
          expect_any_instance_of(Ping).not_to receive(:send_weblogupdatesping)
          expect_any_instance_of(Ping).not_to receive(:send_pingback_or_trackback)
          described_class.perform_now(article)
        end
      end

      context 'given a blog that allows sending outbound pings' do
        let(:send_outbound_pings) { true }

        it 'do nothing when no urls to ping article' do
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return([])
          expect(article).to receive(:html_urls_to_ping).and_return([])
          expect_any_instance_of(Ping).not_to receive(:send_weblogupdatesping)
          expect_any_instance_of(Ping).not_to receive(:send_pingback_or_trackback)
          described_class.perform_now(article)
        end

        it 'do nothing when urls already list in article.pings (already ping ?)' do
          article.pings.create(url: 'an_url_to_ping')

          blog.ping_urls = 'an_url_to_ping'
          expect(article).to receive(:html_urls).and_return(['an_url_to_ping'])

          expect_any_instance_of(Ping).not_to receive(:send_weblogupdatesping)
          expect_any_instance_of(Ping).not_to receive(:send_pingback_or_trackback)

          described_class.perform_now(article)
        end

        it "calls send_weblogupdatesping when it's not already done" do
          new_ping = double(Ping)
          urls_to_ping = [new_ping]
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return(urls_to_ping)
          expect(article).to receive(:permalink_url)
          expect(article).to receive(:html_urls_to_ping).and_return([])
          expect(new_ping).to receive(:send_weblogupdatesping)
          expect(new_ping).not_to receive(:send_pingback_or_trackback)
          described_class.perform_now(article)
        end

        it "calls send_pingback_or_trackback when it's not already done" do
          expect_any_instance_of(Blog).to receive(:urls_to_ping_for).and_return([])
          new_ping = double(Ping)
          expect(article).to receive(:html_urls_to_ping).and_return([new_ping])
          expect(article).to receive(:permalink_url)
          expect(new_ping).to receive(:send_pingback_or_trackback)
          expect(new_ping).not_to receive(:send_weblogupdatesping)
          described_class.perform_now(article)
        end
      end
    end
  end
end
