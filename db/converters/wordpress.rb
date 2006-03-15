#!/usr/bin/env ruby

# WordPress 1.5x converter for typo by Patrick Lenz <patrick@lenz.sh>
#
# MAKE BACKUPS OF EVERYTHING BEFORE RUNNING THIS SCRIPT!
# THIS SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND

require File.dirname(__FILE__) + '/../../config/environment'
require 'optparse'

class WPMigrate
  attr_accessor :options

  def initialize
    self.options = {}
    self.parse_options
    self.convert_categories
    self.convert_entries
    self.convert_prefs
  end

  def convert_categories
    wp_categories = ActiveRecord::Base.connection.select_all(%{
      SELECT cat_name AS name
      FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_categories`
    })

    puts "Converting #{wp_categories.size} categories.."

    wp_categories.each do |cat|
      Category.create(cat) unless Category.find_by_name(cat['name'])
    end
  end

  def convert_entries
    wp_entries = ActiveRecord::Base.connection.select_all(%{
      SELECT
        `#{self.options[:wp_prefix]}_posts`.ID,
        (CASE comment_status WHEN 'closed' THEN '0' ELSE '1' END) AS allow_comments,
        (CASE ping_status WHEN 'closed' THEN '0' ELSE '1' END) AS allow_pings,
        post_title AS title,
        post_content AS body,
        post_excerpt AS excerpt,
        post_date AS created_at,
        post_modified AS updated_at,
        (CASE LENGTH(user_nickname) WHEN '0' THEN user_login ELSE user_nickname END) AS author,
        (CASE post_status WHEN 'publish' THEN '1' ELSE '0' END) AS published,
        post_category
      FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_posts`, `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_users`
      WHERE `#{self.options[:wp_prefix]}_users`.ID = `#{self.options[:wp_prefix]}_posts`.post_author
    })

    puts "Converting #{wp_entries.size} entries.."

    wp_entries.each do |entry|
      a = Article.new
      a.attributes = entry.reject { |k,v| k =~ /^(ID|post_category|body)/ }
      a.text_filter = self.options[:text_filter]
      body = entry['body']
      more_index = body.index('<!--more-->')
      if more_index
      	a.body = body[0...more_index]
      	a.extended = body[more_index+11...body.length]
      else
      	a.body = body
      end
      a.save

      # Assign primary category
      unless entry['post_category'].to_i.zero?
        puts "Assign primary category for entry #{entry['ID']}"

        ActiveRecord::Base.connection.select_all(%{
          SELECT cat_name
          FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_categories`
          WHERE cat_ID = '#{entry['post_category']}'
        }).each do |c|
          a.categories.push_with_attributes(Category.find_by_name(c['cat_name']), :is_primary => 1) rescue nil
        end
      end

      # Fetch category assignments
      puts "Assign remaining categories for entry #{entry['ID']}"
      ActiveRecord::Base.connection.select_all(%{
        SELECT cat_name
        FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_categories`, `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_post2cat`
        WHERE post_id = #{entry['ID']}
        AND `#{self.options[:wp_prefix]}_post2cat`.category_id = `#{self.options[:wp_prefix]}_categories`.cat_ID
      }).each do |c|
        a.categories.push_with_attributes(Category.find_by_name(c['cat_name']), :is_primary => 0)
      end

      # Fetch comments
      ActiveRecord::Base.connection.select_all(%{
        SELECT
          comment_author AS author,
          comment_author_email AS email,
          comment_author_url AS url,
          comment_content AS body,
          comment_date AS created_at,
          comment_author_IP AS ip
        FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_comments`
        WHERE comment_post_ID = #{entry['ID']}
        AND comment_type != 'trackback'
        AND comment_approved = '1'
      }).each do |c|
        a.comments.create(c)
      end

      # Fetch trackbacks
      ActiveRecord::Base.connection.select_all(%{
        SELECT
          comment_author AS blog_name,
          comment_author_url AS url,
          comment_content AS excerpt,
          comment_date AS created_at,
          comment_author_IP AS ip
        FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_comments`
        WHERE comment_post_ID = #{entry['ID']}
        AND comment_type = 'trackback'
        AND comment_approved = '1'
      }).each do |c|
        c['title'] = c['excerpt'].match("<(strong)>(.+?)</\\1>")[2] rescue c['blog_name']
        a.trackbacks.create(c)
      end

    end
  end

  def convert_prefs
    puts "Converting prefs"

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        (CASE option_name
          WHEN 'blogname' THEN 'blog_name'
          WHEN 'default_comment_status' THEN 'default_allow_comments'
          WHEN 'default_ping_status' THEN 'default_allow_pings'
         END) AS name,
        option_value AS value
      FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_options`
      WHERE option_name IN ('blogname', 'default_comment_status', 'default_ping_status')
    }).each do |pref|
      if pref['name'] =~ /^default_allow/
        pref['value'] = (pref['value'] == "open" ? 1 : 0)
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
      opt.banner = "Usage: wordpress.rb [options]"

      opt.on('--db DBNAME', String, 'WordPress database name.') { |d| self.options[:wp_db] = d }
      opt.on('--prefix PREFIX', String, 'WordPress table prefix (defaults to \'wp\').') { |d| self.options[:wp_prefix] = d }
      opt.on('--filter TEXTFILTER', String, 'Textfilter for imported articles (defaults to markdown).') { |d| self.options[:text_filter] = d }

      opt.on_tail('-h', '--help', 'Show this message.') do
        puts opt
        exit
      end

      opt.parse!(ARGV)
    end

    unless self.options.include?(:wp_db)
      puts "See wordpress.rb --help for help."
      exit
    end

    unless self.options.include?(:wp_prefix)
      self.options[:wp_prefix] = "wp"
    end

    unless self.options.include?(:text_filter)
      self.options[:text_filter] = 'markdown'
    end
  end
end

WPMigrate.new
