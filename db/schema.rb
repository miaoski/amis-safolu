# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_04_002733) do

  create_table "definitions", force: :cascade do |t|
    t.integer "term_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "descriptions", force: :cascade do |t|
    t.integer "definition_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "term_id"
    t.index ["term_id"], name: "index_descriptions_on_term_id"
  end

  create_table "examples", force: :cascade do |t|
    t.integer "description_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "raw_contents", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.integer "term_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "loanword", default: false
    t.index ["term_id"], name: "index_raw_contents_on_term_id"
  end

  create_table "stems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "synonyms", force: :cascade do |t|
    t.integer "description_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "term_type", limit: 5
  end

  create_table "terms", force: :cascade do |t|
    t.string "name"
    t.integer "stem_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "repetition"
    t.string "lower_name"
    t.boolean "loanword", default: false
    t.index ["lower_name"], name: "index_terms_on_lower_name"
    t.index ["stem_id"], name: "index_terms_on_stem_id"
  end

end
