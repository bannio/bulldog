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

ActiveRecord::Schema.define(version: 20140819084921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "vat_enabled"
    t.string   "email"
    t.integer  "plan_id"
    t.string   "stripe_customer_token"
    t.integer  "card_last4"
    t.date     "card_expiration"
    t.date     "next_invoice"
    t.date     "date_reminded"
  end

  add_index "accounts", ["plan_id"], name: "index_accounts_on_plan_id", using: :btree

  create_table "bills", force: true do |t|
    t.integer  "account_id"
    t.integer  "customer_id"
    t.integer  "supplier_id"
    t.integer  "category_id"
    t.text     "description"
    t.decimal  "amount",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "invoice_id"
    t.integer  "vat_rate_id"
    t.decimal  "vat",         precision: 8, scale: 2
  end

  add_index "bills", ["account_id"], name: "index_bills_on_account_id", using: :btree
  add_index "bills", ["category_id"], name: "index_bills_on_category_id", using: :btree
  add_index "bills", ["customer_id"], name: "index_bills_on_customer_id", using: :btree
  add_index "bills", ["invoice_id"], name: "index_bills_on_invoice_id", using: :btree
  add_index "bills", ["supplier_id"], name: "index_bills_on_supplier_id", using: :btree
  add_index "bills", ["vat_rate_id"], name: "index_bills_on_vat_rate_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["account_id"], name: "index_categories_on_account_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.text     "address"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default"
  end

  add_index "customers", ["account_id"], name: "index_customers_on_account_id", using: :btree

  create_table "headers", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "headers", ["account_id"], name: "index_headers_on_account_id", using: :btree

  create_table "invoices", force: true do |t|
    t.integer  "account_id"
    t.integer  "customer_id"
    t.date     "date"
    t.string   "number"
    t.decimal  "total",        precision: 8, scale: 2
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "header_id"
    t.boolean  "include_bank"
    t.boolean  "include_vat"
  end

  add_index "invoices", ["account_id"], name: "index_invoices_on_account_id", using: :btree
  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.integer  "amount"
    t.string   "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "sales", force: true do |t|
    t.integer  "plan_id"
    t.integer  "account_id"
    t.string   "state"
    t.string   "stripe_charge_id"
    t.string   "stripe_customer_id"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.text     "error"
    t.integer  "fee_amount"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales", ["account_id"], name: "index_sales_on_account_id", using: :btree
  add_index "sales", ["plan_id"], name: "index_sales_on_plan_id", using: :btree

  create_table "settings", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "address"
    t.string   "postcode"
    t.string   "bank_account_name"
    t.string   "bank_name"
    t.string   "bank_address"
    t.string   "bank_account_no"
    t.string   "bank_bic"
    t.string   "bank_iban"
    t.string   "bank_sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vat_reg_no"
    t.boolean  "include_vat"
    t.boolean  "include_bank"
    t.string   "telephone"
    t.string   "email"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "settings", ["account_id"], name: "index_settings_on_account_id", using: :btree

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suppliers", ["account_id"], name: "index_suppliers_on_account_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vat_rates", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.decimal  "rate",       precision: 5, scale: 2
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vat_rates", ["account_id"], name: "index_vat_rates_on_account_id", using: :btree

end
