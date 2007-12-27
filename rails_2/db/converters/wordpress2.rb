#!/usr/bin/env ruby

# WordPress 1.5x converter for typo by Patrick Lenz <patrick@lenz.sh>
# Updated to work with WordPress 2.0.x by Phillip Toland <toland@mac.com>
#
# See http://fiatdev.com/wp/2006/07/10/wordpress-to-typo-conversion-script/
# for more information.
#
# MAKE BACKUPS OF EVERYTHING BEFORE RUNNING THIS SCRIPT!
# THIS SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND

require File.dirname(__FILE__) + '/../../config/environment'
require 'application'
require 'optparse'

class WP2Migrate
  attr_accessor :options

  def initialize
    self.options = {}
    self.parse_options

    WP2Migrate.execute_without_timestamps do
      self.create_blog
      self.convert_users
      self.convert_categories unless self.options[:tags] 
      self.convert_entries
    end
  end


  # Replaces <code></code> tags with <typo:code> and </typo:code> 
  # Also rewrites Markdown URLs with relative paths to a new base url 
  def replacements(str) 
    str.gsub!('<code', '<typo:code') 
    str.gsub!('</code>', '</typo:code>') 
    if self.options[:base_url] 
      str.gsub!(/\(\/([^\)]*)\)/,"(#{self.options[:base_url]}" +'\1)') 
      str.gsub!(/\[([^\]]*)\]: \/([^$])/, '[\1]:' +"#{self.options[:base_url]}"+'\2') 
    end 
    str 
  end 

  def create_blog
    puts 'Creating Blog...'

    blog = Blog.new

    ActiveRecord::Base.connection.select_all(%{
      SELECT
          (CASE option_name
            WHEN 'blogname' THEN 'blog_name'
  	        WHEN 'blogdescription' THEN 'blog_subtitle'
  	        WHEN 'siteurl' THEN 'canonical_server_url'
            WHEN 'default_comment_status' THEN 'default_allow_comments'
            WHEN 'default_ping_status' THEN 'default_allow_pings'
           END) AS name,
        option_value AS value
      FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_options`
      WHERE option_name IN ('blogname', 'default_comment_status', 'default_ping_status', 'siteurl', 'blogdescription')
    }).each do |pref|
      if pref['name'] =~ /^default_allow/
        pref['value'] = (pref['value'] == "open" ? 1 : 0)
      end

      blog[pref['name']] = pref['value']
    end
    
    blog['send_outbound_pings'] = false
    blog['text_filter'] = self.options[:text_filter]
    blog['comment_text_filter'] = self.options[:text_filter]

    blog.save
  end

  def convert_users
    # The SQL statement below is meant to capture all of the WordPress users
    # who have permission to post content and not the users who just signed up
    # to post a comment. There is some confusion in WP 2.0 about the user levels
    # and user roles. I am currently using the user levels to select the
    # appropriate users even though that is the "old way". If that is a problem,
    # replace the second part of the where clause with:
    #   AND (usermeta.meta_key = 'wp_capabilities' AND INSTR(meta_value, 'subscriber') = 0)
    # which does (mostly) the same thing using the new roles system.
    wp_users = ActiveRecord::Base.connection.select_all(%{
      SELECT
        users.ID AS id,
        user_login AS login,
        user_email AS email,
        display_name AS name
      FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_users` AS users, 
        `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_usermeta` AS usermeta
      WHERE users.ID = usermeta.user_id 
    	  AND (usermeta.meta_key = 'wp_user_level' AND (meta_value > 0 AND meta_value < 10))
    })

    puts "Converting #{wp_users.size} users..."

    wp_users.each do |user|
      u = User.new user
      u.id = user['id']
      u.password = u.password_confirmation = 'password'
      u.save
    end
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
        post_name AS permalink,
        post_date AS created_at,
        post_modified AS updated_at,
        (CASE LENGTH(user_nicename) WHEN '0' THEN user_login ELSE user_nicename END) AS author,
        (CASE post_status WHEN 'publish' THEN '1' ELSE '0' END) AS published,
        post_author AS user_id,
        post_status,
        post_category
      FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_posts`, `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_users`
      WHERE `#{self.options[:wp_prefix]}_users`.ID = `#{self.options[:wp_prefix]}_posts`.post_author
    })

    puts "Converting #{wp_entries.size} entries.."

    wp_entries.each do |entry|
      if entry['post_status'] == 'static'        
        a = Page.new
        a.attributes = entry.reject { |k,v| k =~ /^(ID|post_category|body|post_status|permalink)/ }
        a.name = entry['permalink']
        a.created_at = entry['created_at']
        a.updated_at = entry['updated_at']
      else
        a = Article.new
        a.attributes = entry.reject { |k,v| k =~ /^(ID|post_category|body|post_status)/ }
        a.created_at = entry['created_at'] 
        a.created_at ||= DateTime.now
        a.updated_at = entry['updated_at']
      end
      
      a.text_filter = TextFilter.find(:first, :conditions => [ 'name = ?', self.options[:text_filter] ] ) 
     	
     	body = replacements(entry['body']) 
     	more_index = body.index('<!--more-->') 
     	if more_index 
     	  a.body = body[0...more_index] 
     	  a.extended = body[more_index + 11...body.length] 
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
     	    if self.options[:tags] 
     	      a.keywords = c['cat_name'].downcase || ""; 
     	    else 
     	      a.categories.push_with_attributes(Category.find_by_name(c['cat_name']), :is_primary => 1) rescue nil 
     	    end 
     	  end 
     	end unless a.instance_of?(Page) 
	   
     	# Fetch category assignments 
     	puts "Assign remaining categories for entry #{entry['ID']}"
      ActiveRecord::Base.connection.select_all(%{
        SELECT cat_name
        FROM `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_categories`, `#{self.options[:wp_db]}`.`#{self.options[:wp_prefix]}_post2cat` 
       	WHERE post_id = #{entry['ID']} 
       	  AND `#{self.options[:wp_prefix]}_post2cat`.category_id = `#{self.options[:wp_prefix]}_categories`.cat_ID
      }).each do |c|
        if self.options[:tags] 
          a.keywords ||= "" 
          a.keywords << " " << c['cat_name'].gsub(/\s/,'-').downcase 
        else 
          a.categories.push_with_attributes(Category.find_by_name(c['cat_name']), :is_primary => 0) 
        end 
      end unless a.instance_of?(Page) 

      a.save if self.options[:tags] # force tags to save 

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
      end unless a.instance_of?(Page) 
       
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
      end unless a.instance_of?(Page)

      # Typo internally sets the published_at timestamp so we are going to go
      # behind its back to set them to what they should be.
      ActiveRecord::Base.connection.execute(%{
        UPDATE contents SET published_at = created_at 
        WHERE published_at IS NOT NULL
      })
    end
  end

  def parse_options
    OptionParser.new do |opt|
      opt.banner = "Usage: wordpress.rb [options]"

      opt.on('--db DBNAME', String, 'WordPress database name.') { |d| self.options[:wp_db] = d }
      opt.on('--prefix PREFIX', String, 'WordPress table prefix (defaults to \'wp\').') { |d| self.options[:wp_prefix] = d }
      opt.on('--filter TEXTFILTER', String, 'Textfilter for imported articles (defaults to textile): eg \'markdown smartypants\'') { |d| self.options[:text_filter] = d } 
     	opt.on('--tags', 'Convert categories to tags') { self.options[:tags] = true; } 
     	opt.on('--base-url URL', String, 'Rewrite the base url for Markdown relative paths. (Trailing / required).' ) { |url| self.options[:base_url] = url }
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
      self.options[:text_filter] = 'textile'
    end
  end

  # This method allows to execute a block while deactivating timestamp
  # updating.
  def self.execute_without_timestamps
    old_state = ActiveRecord::Base.record_timestamps
    ActiveRecord::Base.record_timestamps = false

    yield

    ActiveRecord::Base.record_timestamps = old_state
  end
end

WP2Migrate.new
