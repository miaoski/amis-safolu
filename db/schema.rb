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

ActiveRecord::Schema.define(version: 2018_12_16_174152) do

  create_table "raw_contents", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.integer "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_raw_contents_on_term_id"
  end

  create_table "stems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.string "name"
    t.integer "stem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repetition"
    t.index ["stem_id"], name: "index_terms_on_stem_id"
  end

end
