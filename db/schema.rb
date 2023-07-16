# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_12_140502) do
  create_table "blacklisted_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_blacklisted_tokens_on_token"
  end

  create_table "job_applications", force: :cascade do |t|
    t.integer "job_post_id", null: false
    t.integer "user_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id"], name: "index_job_applications_on_job_post_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_posts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_posts_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.string "company"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "jobseeker"
  end

  add_foreign_key "job_applications", "job_posts"
  add_foreign_key "job_applications", "job_posts", on_delete: :cascade
  add_foreign_key "job_applications", "users"
  add_foreign_key "job_posts", "users"
end
