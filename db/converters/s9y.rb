#!/usr/bin/env ruby

# Serendipity (S9Y) 0.8.x converter for typo by Jochen Schalanda <jochen@schalanda.de>
# heavily based on the Wordpress 1.5x converter by Patrick Lenz <patrick@lenz.sh>
#
# MAKE BACKUPS OF EVERYTHING BEFORE RUNNING THIS SCRIPT!
# THIS SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND
#
#
# SECURITY NOTICE:
#
# Migrated users will have the default password "password", since the
# MD5 hashes of S9Y cannot be converted to salted SHA1 hashes which are
# used by Typo.
#

require File.dirname(__FILE__) + '/../../config/environment'
require 'optparse'

class S9YMigrate
  attr_accessor :options

  def initialize
    self.options = {}
    self.parse_options
    self.convert_users
    self.convert_categories
    self.convert_entries
    self.convert_prefs
  end

  def convert_categories
    s9y_categories = ActiveRecord::Base.connection.select_all(%{
      SELECT category_name AS name
      FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}category`
    })

    puts "Converting #{s9y_categories.size} categories.."

    s9y_categories.each do |cat|
      Category.create(cat) unless Category.find_by_name(cat['name'])
    end
  end

  def convert_entries
    s9y_entries = ActiveRecord::Base.connection.select_all(%{
      SELECT
      	id,
        (CASE allow_comments WHEN 'true' THEN '1' ELSE '0' END) AS allow_comments,
        title,
        body,
        extended,
        FROM_UNIXTIME(timestamp) AS created_at,
        FROM_UNIXTIME(last_modified) AS updated_at,
        author,
        authorid AS user_id,
        (CASE isdraft WHEN 'true' THEN '0' ELSE '1' END) AS published
      FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}entries`
    })

    puts "Converting #{s9y_entries.size} entries.."

    s9y_entries.each do |entry|
      a = Article.new
      a.attributes = entry.reject { |k,v| k =~ /^(id)/ }
      a.save

      # Fetch category assignments
      ActiveRecord::Base.connection.select_all(%{
        SELECT category_name
        FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}category`, `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}entrycat`
        WHERE entryid = #{entry['id']}
        AND `#{self.options[:s9y_prefix]}entrycat`.categoryid = `#{self.options[:s9y_prefix]}category`.categoryid
      }).each do |c|
        a.categories.push_with_attributes(Category.find_by_name(c['category_name']), :is_primary => 0)
      end

      # Fetch comments
      ActiveRecord::Base.connection.select_all(%{
        SELECT
          author,
          email,
          url,
          body,
          FROM_UNIXTIME(timestamp) AS created_at,
          ip
        FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}comments`
        WHERE id = #{entry['id']}
        AND type != 'TRACKBACK'
        AND status = 'approved'
      }).each do |c|
        a.comments.create(c)
      end

      # Fetch trackbacks
      ActiveRecord::Base.connection.select_all(%{
        SELECT
          author AS blog_name,
          url,
          title,
          body AS excerpt,
          FROM_UNIXTIME(timestamp) AS created_at,
          ip
        FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}comments`
        WHERE entry_id = #{entry['id']}
        AND type = 'TRACKBACK'
        AND status = 'approved'
      }).each do |c|
        a.trackbacks.create(c)
      end

    end
  end

  def convert_prefs
    puts "Converting prefs"

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        (CASE name
          WHEN 'blogTitle' THEN 'blog_name'
          WHEN 'blogDescription' THEN 'blog_subtitle'
         END) AS name,
        value
      FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}config`
      WHERE name IN ('blogTitle', 'blogDescription')
    }).each do |pref|
      begin
        Setting.find_by_name(pref['name']).update_attribute("value", pref['value'])
      rescue
        Setting.create(pref)
      end
    end
  end

def convert_users
    puts "Converting users"
	puts "** all users will have the default password \"password\" **"
	puts "** you should change it as soon as possible!           **"

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        realname AS name,
        username AS login,
        email
      FROM `#{self.options[:s9y_db]}`.`#{self.options[:s9y_prefix]}authors`
    }).each do |user|
      u = User.new
      u.attributes = user
	  u.password = "password"
      u.save
    end
  end

  def parse_options
    OptionParser.new do |opt|
      opt.banner = "Usage: s9y.rb [options]"

      opt.on('--db DBNAME', String, 'S9Y database name.') { |d| self.options[:s9y_db] = d }
      opt.on('--prefix PREFIX', String, 'S9Y table prefix (defaults to empty string).') { |d| self.options[:s9y_prefix] = d }

      opt.on_tail('-h', '--help', 'Show this message.') do
        puts opt
        exit
      end

      opt.parse!(ARGV)
    end

    unless self.options.include?(:s9y_db)
      puts "See s9y.rb --help for help."
      exit
    end

	unless self.options.include?(:s9y_prefix)
      self.options[:s9y_prefix] = ""
    end

  end
end

S9YMigrate.new
