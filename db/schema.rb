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

ActiveRecord::Schema.define(version: 2021_09_21_030134) do

  create_table "lectures", charset: "utf8mb4", force: :cascade do |t|
    t.integer "lecture_id"
    t.bigint "subject_id"
    t.string "title"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_id"], name: "index_lectures_on_subject_id"
  end

  create_table "subjects", charset: "utf8mb4", force: :cascade do |t|
    t.integer "subject_id"
    t.bigint "teacher_id"
    t.string "title"
    t.string "weekday"
    t.integer "period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["teacher_id"], name: "index_subjects_on_teacher_id"
  end

  create_table "teachers", charset: "utf8mb4", force: :cascade do |t|
    t.integer "teacher_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "lectures", "subjects"
  add_foreign_key "subjects", "teachers"
end
