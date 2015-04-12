# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150207131657) do

  create_table "articles_tags", id: false, force: :cascade do |t|
    t.integer "article_id", limit: 4
    t.integer "tag_id",     limit: 4
  end

  add_index "articles_tags", ["article_id"], name: "index_articles_tags_on_article_id", using: :btree
  add_index "articles_tags", ["tag_id"], name: "index_articles_tags_on_tag_id", using: :btree

  create_table "blogs", force: :cascade do |t|
    t.text   "settings", limit: 65535
    t.string "base_url", limit: 255
  end

  create_table "contents", force: :cascade do |t|
    t.string   "type",           limit: 255
    t.string   "title",          limit: 255
    t.string   "author",         limit: 255
    t.text     "body",           limit: 65535
    t.text     "extended",       limit: 65535
    t.text     "excerpt",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",        limit: 4
    t.string   "permalink",      limit: 255
    t.string   "guid",           limit: 255
    t.integer  "text_filter_id", limit: 4
    t.text     "whiteboard",     limit: 65535
    t.string   "name",           limit: 255
    t.boolean  "published",      limit: 1,     default: false
    t.boolean  "allow_pings",    limit: 1
    t.boolean  "allow_comments", limit: 1
    t.datetime "published_at"
    t.string   "state",          limit: 255
    t.integer  "parent_id",      limit: 4
    t.text     "settings",       limit: 65535
    t.string   "post_type",      limit: 255,   default: "read"
  end

  add_index "contents", ["id", "type"], name: "index_contents_on_id_and_type", using: :btree
  add_index "contents", ["published"], name: "index_contents_on_published", using: :btree
  add_index "contents", ["text_filter_id"], name: "index_contents_on_text_filter_id", using: :btree
  add_index "contents", ["user_id"], name: "index_contents_on_user_id", using: :btree

  create_table "feedback", force: :cascade do |t|
    t.string   "type",             limit: 255
    t.string   "title",            limit: 255
    t.string   "author",           limit: 255
    t.text     "body",             limit: 65535
    t.text     "excerpt",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
    t.string   "guid",             limit: 255
    t.integer  "text_filter_id",   limit: 4
    t.text     "whiteboard",       limit: 65535
    t.integer  "article_id",       limit: 4
    t.string   "email",            limit: 255
    t.string   "url",              limit: 255
    t.string   "ip",               limit: 40
    t.string   "blog_name",        limit: 255
    t.boolean  "published",        limit: 1,     default: false
    t.datetime "published_at"
    t.string   "state",            limit: 255
    t.boolean  "status_confirmed", limit: 1
    t.string   "user_agent",       limit: 255
  end

  add_index "feedback", ["article_id"], name: "index_feedback_on_article_id", using: :btree
  add_index "feedback", ["id", "type"], name: "index_feedback_on_id_and_type", using: :btree
  add_index "feedback", ["text_filter_id"], name: "index_feedback_on_text_filter_id", using: :btree
  add_index "feedback", ["user_id"], name: "index_feedback_on_user_id", using: :btree

  create_table "page_caches", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "page_caches", ["name"], name: "index_page_caches_on_name", using: :btree

  create_table "pings", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.string   "url",        limit: 255
    t.datetime "created_at"
  end

  add_index "pings", ["article_id"], name: "index_pings_on_article_id", using: :btree

  create_table "post_types", force: :cascade do |t|
    t.string "name",        limit: 255
    t.string "permalink",   limit: 255
    t.string "description", limit: 255
  end

  create_table "profiles", force: :cascade do |t|
    t.string "label",    limit: 255
    t.string "nicename", limit: 255
    t.text   "modules",  limit: 65535
  end

  create_table "profiles_rights", id: false, force: :cascade do |t|
    t.integer "profile_id", limit: 4
    t.integer "right_id",   limit: 4
  end

  add_index "profiles_rights", ["profile_id"], name: "index_profiles_rights_on_profile_id", using: :btree

  create_table "redirections", force: :cascade do |t|
    t.integer "content_id",  limit: 4
    t.integer "redirect_id", limit: 4
  end

  add_index "redirections", ["content_id"], name: "index_redirections_on_content_id", using: :btree
  add_index "redirections", ["redirect_id"], name: "index_redirections_on_redirect_id", using: :btree

  create_table "redirects", force: :cascade do |t|
    t.string   "from_path",  limit: 255
    t.string   "to_path",    limit: 255
    t.string   "origin",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "size",            limit: 4
    t.string   "upload",          limit: 255
    t.string   "mime",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id",      limit: 4
    t.boolean  "itunes_metadata", limit: 1
    t.string   "itunes_author",   limit: 255
    t.string   "itunes_subtitle", limit: 255
    t.integer  "itunes_duration", limit: 4
    t.text     "itunes_summary",  limit: 65535
    t.string   "itunes_keywords", limit: 255
    t.string   "itunes_category", limit: 255
    t.boolean  "itunes_explicit", limit: 1
  end

  add_index "resources", ["article_id"], name: "index_resources_on_article_id", using: :btree

  create_table "sidebars", force: :cascade do |t|
    t.integer "active_position", limit: 4
    t.text    "config",          limit: 65535
    t.integer "staged_position", limit: 4
    t.string  "type",            limit: 255
  end

  add_index "sidebars", ["id", "type"], name: "index_sidebars_on_id_and_type", using: :btree

  create_table "sitealizer", force: :cascade do |t|
    t.string   "path",       limit: 255
    t.string   "ip",         limit: 255
    t.string   "referer",    limit: 255
    t.string   "language",   limit: 255
    t.string   "user_agent", limit: 255
    t.datetime "created_at"
    t.date     "created_on"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name", limit: 255
  end

  create_table "text_filters", force: :cascade do |t|
    t.string "name",        limit: 255
    t.string "description", limit: 255
    t.string "markup",      limit: 255
    t.text   "filters",     limit: 65535
    t.text   "params",      limit: 65535
  end

  create_table "triggers", force: :cascade do |t|
    t.integer  "pending_item_id",   limit: 4
    t.string   "pending_item_type", limit: 255
    t.datetime "due_at"
    t.string   "trigger_method",    limit: 255
  end

  add_index "triggers", ["pending_item_id", "pending_item_type"], name: "index_triggers_on_pending_item_id_and_pending_item_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",                     limit: 255
    t.string   "password",                  limit: 255
    t.text     "email",                     limit: 65535
    t.text     "name",                      limit: 65535
    t.boolean  "notify_via_email",          limit: 1
    t.boolean  "notify_on_new_articles",    limit: 1
    t.boolean  "notify_on_comments",        limit: 1
    t.integer  "profile_id",                limit: 4
    t.string   "remember_token",            limit: 255
    t.datetime "remember_token_expires_at"
    t.string   "text_filter_id",            limit: 255,   default: "1"
    t.string   "state",                     limit: 255,   default: "active"
    t.datetime "last_connection"
    t.text     "settings",                  limit: 65535
    t.integer  "resource_id",               limit: 4
  end

  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree
  add_index "users", ["resource_id"], name: "index_users_on_resource_id", using: :btree
  add_index "users", ["text_filter_id"], name: "index_users_on_text_filter_id", using: :btree

end
