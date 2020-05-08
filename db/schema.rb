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

ActiveRecord::Schema.define(version: 20200508121039) do

  create_table "applies", force: :cascade do |t|
    t.date "month"
    t.string "month_instructor_confirmation", default: "選択してください"
    t.string "month_to_who"
    t.string "mark_month_instructor_confirmation", default: "申請中"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "change"
    t.index ["user_id"], name: "index_applies_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "plan_finished_at"
    t.string "business_processing_contents"
    t.string "instructor_confirmation", default: "選択してください"
    t.boolean "tomorrow"
    t.string "mark_instructor_confirmation", default: "なし"
    t.boolean "change"
    t.string "kintai_change_instructor_confirmation", default: " "
    t.string "mark_kintai_change_instructor_confirmation", default: "申請中"
    t.datetime "applying_started_at"
    t.datetime "applying_finished_at"
    t.string "kintai_to_who", default: " "
    t.boolean "kintai_tomorrow"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "base_type"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2020-05-07 23:00:00"
    t.datetime "designated_work_start_time", default: "2020-05-08 00:00:00"
    t.datetime "designated_work_end_time", default: "2020-05-08 09:00:00"
    t.string "uid"
    t.integer "employee_number"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
