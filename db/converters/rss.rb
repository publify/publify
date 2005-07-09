#!/usr/bin/env ruby

# RSS 0.9/2.0 converter for typo by Chris Lee <clee@kde.org>
#
# No need to make a backup of the original blog, really. This takes a URL for a
# read-only import, so there's not really any chance of it munging the original
# blog's data, unless somehow an HTTP GET causes your blog server to ignite.
#
# Even so, this script is still PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.

require File.dirname(__FILE__) + '/../../config/environment'
require 'optparse'
require 'net/http'
require 'rss/2.0'

class RSSMigrate
  attr_accessor :options

  def initialize
    self.options = {}
    self.parse_options
    self.convert_entries
  end

  def convert_entries
    feed = Net::HTTP.get(URI.parse(self.options[:url]))
    rss = RSS::Parser.parse(feed)
    puts "Converting #{rss.items.length} entries..."
    rss.items.each do |item|
      puts "Converting '#{item.title}'"
      a = Article.new
      a.author = self.options[:author]
      a.title = item.title
      a.body = item.description
      a.created_at = item.pubDate
      a.save
    end
  end

  def parse_options
    OptionParser.new do |opt|
      opt.banner = 'Usage: rss.rb [options]'

      opt.on('-a', '--author AUTHOR', 'Username of author in typo') do |a|
        self.options[:author] = a
      end

      opt.on('-u', '--url URL', 'URL of RSS feed to import.') do |u|
        self.options[:url] = u
      end

      opt.on_tail('-h', '--help', 'Show this message.') do
        puts opt
        exit
      end

      opt.parse!(ARGV)
    end

    unless self.options.include?(:author) and self.options.include?(:url)
      puts 'See rss.rb --help for help.'
      exit
    end
  end
end

RSSMigrate.new
