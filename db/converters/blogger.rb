#!/usr/bin/env ruby

# Blogger converter to publify
# Shamelessly copied from the RSS/Atom converter by Lennon Day-Reynolds

require File.dirname(__FILE__) + '/../../config/environment'
require 'optparse'
require 'feedzirra'

class BloggerConverter
  BLOGGER_POST = 'http://schemas.google.com/blogger/2008/kind#post'

  attr_accessor :options

  def initialize
    self.options = {}
    parse_options
    convert_entries
  end

  def convert_entries
    feed = Feedzirra::Feed.fetch_and_parse(options[:url])
    puts "Converting #{feed.entries.length} entries..."

    blog = Blog.default
    ping_store = blog.send_outbound_pings
    blog.send_outbound_pings = false # pings have to be diabled or the script crashes because too many connections are opened
    blog.save

    feed.entries.each do |item|
      create_article item if item.categories.include? BLOGGER_POST
    end

    blog.send_outbound_pings = ping_store
    blog.save
  end

  def create_article(entry)
    a = Article.new
    entry_author = create_author entry.author
    a.set_author entry_author
    a.title = entry.title
    a.body = entry.content
    a.created_at = entry.published
    a.published_at = entry.published
    a.text_filter_id = 1
    a.add_category Category.first
    a.keywords = entry.categories - [BLOGGER_POST]
    a.allow_pings = false
    a.allow_comments = false

    puts "Converted '#{entry.title}'" if a.save
  end

  def create_author(name)
    unless User.exists? name: name
      user = User.new
      para = { 'login' => name,
               'name'  => name,
               'nickname'  => name,
               'email' => name + '@fake.com',
               'password' => 'password',
               'profile_id' => 2,
               'notify_via_email' => false,
               'notify_on_comments' => false,
               'notify_on_new_articles' => false,
               'text_filter_id' => 1 }
      user.attributes = para
      user.save
    end

    User.where(name: name).first
  end

  def parse_options
    OptionParser.new do |opt|
      opt.banner = 'Usage: feed.rb [options]'

      opt.on('-u', '--url URL', 'URL of RSS feed to import.') do |u|
        options[:url] = u
      end

      opt.on_tail('-h', '--help', 'Show this message.') do
        puts opt
        exit
      end

      opt.parse!(ARGV)
    end

    unless options.include?(:url)
      puts 'See feed.rb --help for help.'
      exit
    end
  end
end

BloggerConverter.new
