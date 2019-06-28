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

ActiveRecord::Schema.define(version: 20190628151539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devisememberships", force: :cascade do |t|
    t.integer "person_id",                   null: false
    t.integer "group_id",                    null: false
    t.string  "role",      default: "owner"
  end

  add_index "devisememberships", ["person_id", "group_id"], name: "index_devisememberships_on_person_id_and_group_id", unique: true, using: :btree

  create_table "documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.string   "body"
  end

  create_table "documents_groups", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "group_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "documents_groups", ["document_id"], name: "index_documents_groups_on_document_id", using: :btree
  add_index "documents_groups", ["group_id"], name: "index_documents_groups_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "invites", force: :cascade do |t|
    t.string   "email"
    t.integer  "group_id",     null: false
    t.integer  "sender_id",    null: false
    t.integer  "recipient_id"
    t.string   "token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "invites", ["group_id", "token"], name: "index_invites_on_group_id_and_token", unique: true, using: :btree
  add_index "invites", ["sender_id", "group_id", "email"], name: "index_invites_on_sender_id_and_group_id_and_email", unique: true, using: :btree
  add_index "invites", ["sender_id", "group_id"], name: "index_invites_on_sender_id_and_group_id", unique: true, using: :btree

  create_table "memberships", force: :cascade do |t|
    t.string  "role",     default: "owner"
    t.integer "user_id",                    null: false
    t.integer "group_id",                   null: false
  end

  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true, using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree

  create_table "testing", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.string "food", limit: 20, null: false
  end

  add_index "testing", ["name", "food"], name: "testing_name_food_key", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string "name",  null: false
    t.string "email"
  end

  add_foreign_key "documents_groups", "documents"
  add_foreign_key "documents_groups", "groups"
end
