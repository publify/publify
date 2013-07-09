#!/usr/bin/env ruby

# TextPattern 1.x converter for publify by Patrick Lenz <patrick@lenz.sh>
#
# MAKE BACKUPS OF EVERYTHING BEFORE RUNNING THIS SCRIPT!
# THIS SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND

require File.dirname(__FILE__) + '/../../config/environment'
require 'optparse'

class TXPMigrate
  attr_accessor :options

  def initialize
    self.options = {}
    self.parse_options
    self.convert_categories
    self.convert_entries
    self.convert_prefs
  end

  def convert_categories
    txp_categories = ActiveRecord::Base.connection.select_all(%{
      SELECT name
      FROM `#{self.options[:txp_db]}`.`#{self.options[:txp_pfx]}`txp_category
      WHERE parent = 'root'
      AND type = 'article'
    })

    puts "Converting #{txp_categories.size} categories.."

    txp_categories.each do |cat|
      Category.create(cat) unless Category.find_by_name(cat['name'])
    end
  end

  def convert_entries
    txp_entries = ActiveRecord::Base.connection.select_all(%{
      SELECT
        ID,
        Annotate AS allow_comments,
        1 AS allow_pings,
        Title AS title,
        (CASE LENGTH(Body) WHEN 0 THEN Excerpt ELSE Body END) AS body,
        Body_html AS body_html,
        Excerpt AS excerpt,
        Keywords AS keywords,
        Posted AS created_at,
        LastMod AS updated_at,
        AuthorID AS author,
        (CASE textile_body WHEN '1' THEN 'textile' ELSE 'none' END) AS text_filter,
        (CASE Status WHEN '1' THEN '0' ELSE '1' END) AS published,
        Category1, Category2
      FROM `#{self.options[:txp_db]}`..`#{self.options[:txp_pfx]}`textpattern
    })

    puts "Converting #{txp_entries.size} entries.."

    txp_entries.each do |entry|
      a = Article.new
      a.attributes = entry.reject { |k,v| k =~ /^(Category|ID)/ }
      a.save

      # Assign categories
      puts "Assign primary category for entry #{entry['ID']}"
      a.categories.push_with_attributes(Category.find_by_name(entry['Category1']), :is_primary => 1) rescue nil
      puts "Assign secondary category for entry #{entry['ID']}"
      a.categories.push_with_attributes(Category.find_by_name(entry['Category2']), :is_primary => 0) rescue nil

      # Fetch comments
      ActiveRecord::Base.connection.select_all(%{
        SELECT
          name AS author,
          email AS email,
          web AS url,
          message AS body,
          message as body_html,
          posted AS created_at,
          ip AS ip
        FROM `#{self.options[:txp_db]}`..`#{self.options[:txp_pfx]}`txp_discuss
        WHERE parentid = #{entry['ID']}
      }).each do |c|
        a.comments.create(c)
      end

    end
  end

  def convert_prefs
    puts "Converting prefs"

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        (CASE name
          WHEN 'sitename' THEN 'blog_name'
          WHEN 'comments_on_default' THEN 'default_allow_comments'
          WHEN 'use_textile' THEN 'text_filter'
         END) AS name,
        val AS value
      FROM `#{self.options[:txp_db]}`..`#{self.options[:txp_pfx]}`txp_prefs
      WHERE name IN ('sitename', 'comments_on_default', 'use_textile')
    }).each do |pref|
      if pref['name'] == "text_filter" and pref['value'].to_i > 0
        pref['value'] = 'textile'
      end

      begin
        Setting.find_by_name(pref['name']).update_attribute("value", pref['value'])
      rescue
        Setting.create(pref)
      end
    end
  end

  def parse_options
    OptionParser.new do |opt|
      opt.banner = "Usage: textpattern.rb [options]"

      opt.on('--db DBNAME', String, 'Text Pattern database name.') { |d| self.options[:txp_db] = d }
      opt.on('--pf PREFIX', String, 'Textpattern table prefix.') { |p| self.options[:txp_pfx] = p }

      opt.on_tail('-h', '--help', 'Show this message.') do
        puts opt
        exit
      end

      opt.parse!(ARGV)
    end

    unless self.options.include?(:txp_db)
      puts "See textpattern.rb --help for help."
      exit
    end
  end
end

TXPMigrate.new
