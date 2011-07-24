class SerializeBlogAttributes < ActiveRecord::Migration
  class BareSetting < ActiveRecord::Base
    include BareMigration
    belongs_to :blog, :class_name => "SerializeBlogAttributes::BareBlog"

    def self.with_blog_scope(id, &block)
      options = {}
      options[:conditions] = ["blog_id = ?", id]
      with_scope(:find => options, &block)
    end

  end

  class BareBlog < ActiveRecord::Base
    include BareMigration
    serialize :settings

    class SettingSpec
      attr_accessor :key, :type, :default

      def initialize(key, type, default)
        self.key     = key
        self.type    = type
        self.default = default
      end

      def normalize_value(line)
        if !line || line.value.nil?
          return default
        end
        value = line.value
        case type
        when :boolean
          ! value.match(/^(?:f(?:alse)?|0|)$/)
        when :integer
          value.to_i
        when :string
          value
        else
          YAML::load(value)
        end
      end

      def stringify_value(value)
        case type
        when :boolean
          value.to_s
        when :integer
          value.to_s
        when :string
          value
        else
          value.to_yaml
        end
      end
    end

    def self.fields(key = nil)
      @@fields ||= { }
      key ? @@fields[key.to_sym] : @@fields
    end

    def self.setting(key, type, default)
      fields[key.to_sym] = SettingSpec.new(key.to_sym, type, default)
    end

    # Description
    setting :blog_name,                  :string, 'My Shiny Weblog!'
    setting :blog_subtitle,              :string, ''
    setting :geourl_location,            :string, ''

    # Spam
    setting :sp_global,                  :boolean, false
    setting :sp_article_auto_close,      :integer, 0
    setting :sp_allow_non_ajax_comments, :boolean, true
    setting :sp_url_limit,               :integer, 0

    # Podcasting
    setting :itunes_explicit,            :boolean, false
    setting :itunes_author,              :string, ''
    setting :itunes_subtitle,            :string, ''
    setting :itunes_summary,             :string, ''
    setting :itunes_owner,               :string, ''
    setting :itunes_email,               :string, ''
    setting :itunes_name,                :string, ''
    setting :itunes_copyright,           :string, ''

    # Mostly Behaviour
    setting :text_filter,                :string, ''
    setting :comment_text_filter,        :string, ''
    setting :limit_article_display,      :integer, 10
    setting :limit_rss_display,          :integer, 10
    setting :default_allow_pings,        :boolean, false
    setting :default_allow_comments,     :boolean, true
    setting :link_to_author,             :boolean, false
    setting :show_extended_on_rss,       :boolean, true
    setting :theme,                      :string, 'azure'
    setting :use_gravatar,               :boolean, false
    setting :ping_urls,                  :string, "http://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
    setting :send_outbound_pings,        :boolean, true
    setting :email_from,                 :string, 'scott@sigkill.org'

    # Jabber config
    setting :jabber_address,             :string, ''
    setting :jabber_password,            :string, ''
  end


  def self.up
    add_column :blogs, :settings, :text
    unless $schema_generator
      begin
        BareSetting.transaction do
          BareBlog.find(:all).each do |blog|
            blog.settings = { }
            BareSetting.with_blog_scope(blog.id) do
              BareBlog.fields.each do |key, spec|
                next unless setting = BareSetting.find_by_name(key.to_s, :limit => 1)
                blog.settings[key.to_s] =
                  spec.normalize_value(setting)
                BareSetting.delete(setting.id)
              end
            end
            blog.save
          end
        end
      rescue Exception => e
        remove_column :blogs, :settings rescue nil
        raise e
      end
    end
    drop_table :settings
  end

  def self.down
    begin
      create_settings
      unless $schema_generator
        BareSetting.transaction do
          BareBlog.find(:all).each do |blog|
            blog.settings ||= { }
            BareSetting.with_scope(:create => { :blog_id => blog.id }) do
              BareBlog.fields.each do |key, spec|
                next unless blog.settings.has_key?(key.to_s)
                BareSetting.create!(:name => key.to_s,
                                    :value => spec.stringify_value(blog.settings[key.to_s]))
              end
            end
          end
        end
      end
      remove_column :blogs, :settings rescue nil
    rescue Exception => e
      drop_table :settings rescue nil
      raise e
    end
  end

  def self.create_settings
    create_table :settings do |t|
      t.column :name,     :string, :limit => 255
      t.column :value,    :string, :limit => 255
      t.column :position, :integer
      t.column :blog_id,  :integer
    end
  end
end
