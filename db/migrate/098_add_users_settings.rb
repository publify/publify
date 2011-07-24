class AddUsersSettings < ActiveRecord::Migration
  class BareSetting < ActiveRecord::Base
    include BareMigration
    belongs_to :user, :class_name => "AddUsersSettings::BareUser"
  end

  class BareUser < ActiveRecord::Base
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

    setting :notify_watch_my_articles,   :boolean, true
    setting :editor,                     :string, 'visual'
    setting :firstname,                  :string, ''
    setting :lastname,                   :string, ''
    setting :nickname,                   :string, ''
    setting :description,                :string, ''
    setting :url,                        :string, ''
    setting :msn,                        :string, ''
    setting :aim,                        :string, ''
    setting :yahoo,                      :string, ''
    setting :twitter,                    :string, ''
    setting :jabber,                     :string, ''
    setting :show_url,                   :boolean, false
    setting :show_msn,                   :boolean, false
    setting :show_aim,                   :boolean, false
    setting :show_yahoo,                 :boolean, false
    setting :show_twitter,               :boolean, false
    setting :show_jabber,                :boolean, false

  end

  def self.up
    # There must be a better way to do it but...
    # 1. I didn't find it.
    # 2. I'm lost in the countryside where I need to go to the back of the
    # garden to have a phone connection and in the middle of a field to have
    # a chance to get my emails.
    #
    # Problem: settings names overlap fields names.
    # Solution: rename columns, migrate, remove columns.
    #
    # At least it works
    #
    # Some fields were not migrated because we do some User.find on them :
    # – notify_via_email
    # – notify_on_new_articles
    # – notify_on_comments
    #

    rename_column :users, :notify_watch_my_articles, :s_notify_watch_my_articles
    rename_column :users, :editor,                   :s_editor
    rename_column :users, :firstname,                :s_firstname
    rename_column :users, :lastname,                 :s_lastname
    rename_column :users, :nickname,                 :s_nickname
    rename_column :users, :description,              :s_description
    rename_column :users, :url,                      :s_url
    rename_column :users, :msn,                      :s_msn
    rename_column :users, :aim,                      :s_aim
    rename_column :users, :yahoo,                    :s_yahoo
    rename_column :users, :twitter,                  :s_twitter
    rename_column :users, :jabber,                   :s_jabber
    rename_column :users, :show_url,                 :s_show_url
    rename_column :users, :show_msn,                 :s_show_msn
    rename_column :users, :show_aim,                 :s_show_aim
    rename_column :users, :show_yahoo,               :s_show_yahoo
    rename_column :users, :show_twitter,             :s_show_twitter
    rename_column :users, :show_jabber,              :s_show_jabber
    add_column :users, :settings, :text

    unless $schema_generator
      begin
        BareSetting.transaction do
          BareUser.find(:all).each do |user|
            user.settings = { }
#            user.settings['notify_via_email'] = user.s_notify_via_email
#            user.settings['notify_on_new_articles'] = user.s_notify_on_new_articles
#            user.settings['notify_on_comments'] = user.s_notify_on_comments
            user.settings['notify_watch_my_articles'] = user.s_notify_watch_my_articles
#            user.settings['text_filter_id'] = user.s_text_filter_id
            user.settings['editor'] = user.s_editor
            user.settings['firstname'] = user.s_firstname
            user.settings['lastname'] = user.s_lastname
            user.settings['nickname'] = user.s_nickname
            user.settings['description'] = user.s_description
            user.settings['url'] = user.s_url
            user.settings['msn'] = user.s_msn
            user.settings['aim'] = user.s_aim
            user.settings['yahoo'] = user.s_yahoo
            user.settings['twitter'] = user.s_twitter
            user.settings['jabber'] = user.s_jabber
            user.settings['show_url'] = user.s_show_url
            user.settings['show_msn'] = user.s_show_msn
            user.settings['show_aim'] = user.s_show_aim
            user.settings['show_yahoo'] = user.s_show_yahoo
            user.settings['show_twitter'] = user.s_show_twitter
            user.settings['show_jabber'] = user.s_show_jabber
            user.save
          end
        end
      rescue Exception => e
        rename_column :users, :s_notify_watch_my_articles, :notify_watch_my_articles
        rename_column :users, :s_editor,                   :editor
        rename_column :users, :s_firstname,                :firstname
        rename_column :users, :s_lastname,                 :lastname
        rename_column :users, :s_nickname,                 :nickname
        rename_column :users, :s_description,              :description
        rename_column :users, :s_url,                      :url
        rename_column :users, :s_msn,                      :msn
        rename_column :users, :s_aim,                      :aim
        rename_column :users, :s_yahoo,                    :yahoo
        rename_column :users, :s_twitter,                  :twitter
        rename_column :users, :s_jabber,                   :jabber
        rename_column :users, :s_show_url,                 :show_url
        rename_column :users, :s_show_msn,                 :show_msn
        rename_column :users, :s_show_aim,                 :show_aim
        rename_column :users, :s_show_yahoo,               :show_yahoo
        rename_column :users, :s_show_twitter,             :show_twitter
        rename_column :users, :s_show_jabber,              :show_jabber
        remove_column :users, :settings rescue nil
        raise e
      end
    end

    remove_column :users, :s_notify_watch_my_articles
    remove_column :users, :s_editor
    remove_column :users, :s_firstname
    remove_column :users, :s_lastname
    remove_column :users, :s_nickname
    remove_column :users, :s_description
    remove_column :users, :s_url
    remove_column :users, :s_msn
    remove_column :users, :s_aim
    remove_column :users, :s_yahoo
    remove_column :users, :s_twitter
    remove_column :users, :s_jabber
    remove_column :users, :s_show_url
    remove_column :users, :s_show_msn
    remove_column :users, :s_show_aim
    remove_column :users, :s_show_yahoo
    remove_column :users, :s_show_twitter
    remove_column :users, :s_show_jabber

  end

  def self.down
    # FIXME: The code below does not reverse this migration!
    raise ActiveRecord::IrreversibleMigration
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
