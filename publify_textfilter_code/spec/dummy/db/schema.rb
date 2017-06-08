# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170605103452) do

  create_table "blogs", force: :cascade do |t|
    t.text   "settings"
    t.string "base_url"
  end

  create_table "contents", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.string   "author"
    t.text     "body"
    t.text     "extended"
    t.text     "excerpt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "permalink"
    t.string   "guid"
    t.integer  "text_filter_id"
    t.text     "whiteboard"
    t.string   "name"
    t.boolean  "allow_pings"
    t.boolean  "allow_comments"
    t.datetime "published_at"
    t.string   "state"
    t.integer  "parent_id"
    t.text     "settings"
    t.string   "post_type",      default: "read"
    t.integer  "blog_id",                         null: false
    t.index ["id", "type"], name: "index_contents_on_id_and_type"
    t.index ["text_filter_id"], name: "index_contents_on_text_filter_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "contents_tags", id: false, force: :cascade do |t|
    t.integer "content_id"
    t.integer "tag_id"
    t.index ["content_id"], name: "index_contents_tags_on_content_id"
    t.index ["tag_id"], name: "index_contents_tags_on_tag_id"
  end

  create_table "feedback", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.string   "author"
    t.text     "body"
    t.text     "excerpt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "guid"
    t.integer  "text_filter_id"
    t.text     "whiteboard"
    t.integer  "article_id"
    t.string   "email"
    t.string   "url"
    t.string   "ip",             limit: 40
    t.string   "blog_name"
    t.datetime "published_at"
    t.string   "state"
    t.string   "user_agent"
    t.index ["article_id"], name: "index_feedback_on_article_id"
    t.index ["id", "type"], name: "index_feedback_on_id_and_type"
    t.index ["text_filter_id"], name: "index_feedback_on_text_filter_id"
    t.index ["user_id"], name: "index_feedback_on_user_id"
  end

  create_table "page_caches", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_page_caches_on_name"
  end

  create_table "pings", force: :cascade do |t|
    t.integer  "article_id"
    t.string   "url"
    t.datetime "created_at"
    t.index ["article_id"], name: "index_pings_on_article_id"
  end

  create_table "post_types", force: :cascade do |t|
    t.string "name"
    t.string "permalink"
    t.string "description"
  end

  create_table "redirects", force: :cascade do |t|
    t.string   "from_path"
    t.string   "to_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_id"
    t.integer  "blog_id"
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "size"
    t.string   "upload"
    t.string   "mime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_id"
    t.boolean  "itunes_metadata"
    t.string   "itunes_author"
    t.string   "itunes_subtitle"
    t.integer  "itunes_duration"
    t.text     "itunes_summary"
    t.string   "itunes_keywords"
    t.string   "itunes_category"
    t.boolean  "itunes_explicit"
    t.integer  "blog_id",         null: false
    t.index ["content_id"], name: "index_resources_on_content_id"
  end

  create_table "sidebars", force: :cascade do |t|
    t.integer "active_position"
    t.text    "config"
    t.integer "staged_position"
    t.string  "type"
    t.integer "blog_id",         null: false
    t.index ["id", "type"], name: "index_sidebars_on_id_and_type"
  end

  create_table "sitealizer", force: :cascade do |t|
    t.string   "path"
    t.string   "ip"
    t.string   "referer"
    t.string   "language"
    t.string   "user_agent"
    t.datetime "created_at"
    t.date     "created_on"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.integer  "blog_id"
  end

  create_table "text_filters", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "markup"
    t.text   "filters"
    t.text   "params"
  end

  create_table "triggers", force: :cascade do |t|
    t.integer  "pending_item_id"
    t.string   "pending_item_type"
    t.datetime "due_at"
    t.string   "trigger_method"
    t.index ["pending_item_id", "pending_item_type"], name: "index_triggers_on_pending_item_id_and_pending_item_type"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "encrypted_password",        default: "",       null: false
    t.string   "email",                     default: "",       null: false
    t.text     "name"
    t.boolean  "notify_via_email"
    t.boolean  "notify_on_new_articles"
    t.boolean  "notify_on_comments"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "text_filter_id",            default: "1"
    t.string   "state",                     default: "active"
    t.datetime "last_connection"
    t.text     "settings"
    t.integer  "resource_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["resource_id"], name: "index_users_on_resource_id"
    t.index ["text_filter_id"], name: "index_users_on_text_filter_id"
  end

end
