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

ActiveRecord::Schema.define(version: 20160827125425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "administrators", force: :cascade do |t|
    t.string   "name"
    t.string   "email",              default: "",    null: false
    t.boolean  "main",               default: false, null: false
    t.string   "encrypted_password", default: "",    null: false
    t.integer  "sign_in_count",      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0,     null: false
    t.datetime "locked_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true, using: :btree
  end

  create_table "administrators_roles", id: false, force: :cascade do |t|
    t.integer "administrator_id", null: false
    t.integer "role_id",          null: false
  end

  create_table "councillors", force: :cascade do |t|
    t.string   "name"
    t.integer  "party_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "deleted_at"
    t.string   "username"
    t.string   "encrypted_password"
    t.boolean  "is_active",          default: true,  null: false
    t.boolean  "is_holder",          default: false, null: false
    t.index ["party_id"], name: "index_councillors_on_party_id", using: :btree
  end

  create_table "parties", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "subject"
    t.integer  "role_id"
    t.string   "actions",    default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["role_id"], name: "index_permissions_on_role_id", using: :btree
  end

  create_table "plenary_sessions", force: :cascade do |t|
    t.string   "title"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_plenary_sessions_on_deleted_at", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "councillor_id"
    t.string   "title"
    t.datetime "deleted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["councillor_id"], name: "index_projects_on_councillor_id", using: :btree
    t.index ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "description"
    t.boolean  "full_control", default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "councillor_id"
    t.integer  "plenary_session_id"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["councillor_id"], name: "index_votes_on_councillor_id", using: :btree
    t.index ["deleted_at"], name: "index_votes_on_deleted_at", using: :btree
    t.index ["plenary_session_id"], name: "index_votes_on_plenary_session_id", using: :btree
    t.index ["project_id"], name: "index_votes_on_project_id", using: :btree
  end

  add_foreign_key "councillors", "parties"
  add_foreign_key "permissions", "roles"
  add_foreign_key "projects", "councillors"
  add_foreign_key "votes", "councillors"
  add_foreign_key "votes", "plenary_sessions"
  add_foreign_key "votes", "projects"
end
