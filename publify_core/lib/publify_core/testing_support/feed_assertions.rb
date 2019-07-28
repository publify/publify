# frozen_string_literal: true

require "feedjira"
require "rexml/document"

module PublifyCore
  module TestingSupport
    module FeedAssertions
      # TODO: Clean up use of these Test::Unit style expectations
      def assert_xml(xml)
        expect(xml).not_to be_empty
        expect do
          assert REXML::Document.new(xml)
        end.not_to raise_error
      end

      def assert_atom10(feed, count)
        parsed_feed = Feedjira.parse(feed)
        assert_atom10_feed parsed_feed, count
      end

      def assert_atom10_feed(parsed_feed, count)
        expect(parsed_feed).to be_instance_of Feedjira::Parser::Atom
        expect(parsed_feed.title).not_to be_nil
        expect(parsed_feed.entries.count).to eq count
      end

      def assert_correct_atom_generator(feed)
        xml = Nokogiri::XML.parse(feed)
        generator = xml.css("generator").first
        expect(generator.content).to eq("Publify")
        expect(generator["version"]).to eq(PublifyCore::VERSION)
      end

      def assert_rss20(feed, count)
        parsed_feed = Feedjira.parse(feed)
        assert_rss20_feed parsed_feed, count
      end

      def assert_rss20_feed(parsed_feed, count)
        expect(parsed_feed).to be_instance_of Feedjira::Parser::RSS
        expect(parsed_feed.version).to eq "2.0"
        expect(parsed_feed.title).not_to be_nil
        expect(parsed_feed.entries.count).to eq count
      end
    end
  end
end
