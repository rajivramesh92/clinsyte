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

ActiveRecord::Schema.define(version: 20160930113234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "creator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "request_id"
    t.string   "type"
    t.binary   "description"
    t.integer  "choice_id"
    t.binary   "value"
  end

  add_index "answers", ["choice_id"], name: "index_answers_on_choice_id", using: :btree
  add_index "answers", ["creator_id"], name: "index_answers_on_creator_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["request_id"], name: "index_answers_on_request_id", using: :btree

  create_table "appointment_preferences", force: :cascade do |t|
    t.integer  "physician_id"
    t.boolean  "auto_confirm", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "appointment_preferences", ["physician_id"], name: "index_appointment_preferences_on_physician_id", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "physician_id"
    t.integer  "patient_id"
    t.date     "date"
    t.float    "from_time"
    t.float    "to_time"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "appointments", ["patient_id"], name: "index_appointments_on_patient_id", using: :btree
  add_index "appointments", ["physician_id"], name: "index_appointments_on_physician_id", using: :btree

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "careteam_memberships", force: :cascade do |t|
    t.integer  "careteam_id"
    t.integer  "member_id"
    t.integer  "level",       default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "careteam_memberships", ["careteam_id"], name: "index_careteam_memberships_on_careteam_id", using: :btree
  add_index "careteam_memberships", ["member_id"], name: "index_careteam_memberships_on_member_id", using: :btree

  create_table "careteams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "patient_id"
  end

  add_index "careteams", ["patient_id"], name: "index_careteams_on_patient_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_strains", id: false, force: :cascade do |t|
    t.integer "strain_id",   null: false
    t.integer "category_id", null: false
  end

  add_index "categories_strains", ["category_id"], name: "index_categories_strains_on_category_id", using: :btree
  add_index "categories_strains", ["strain_id"], name: "index_categories_strains_on_strain_id", using: :btree

  create_table "choices", force: :cascade do |t|
    t.integer  "question_id"
    t.binary   "option"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "choices", ["question_id"], name: "index_choices_on_question_id", using: :btree

  create_table "compound_strain_tag_connections", force: :cascade do |t|
    t.integer  "compound_strain_id"
    t.integer  "tag_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "compound_strains", force: :cascade do |t|
    t.integer  "compound_id"
    t.integer  "strain_id"
    t.decimal  "high"
    t.decimal  "low"
    t.decimal  "average"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "compound_strains", ["compound_id"], name: "index_compound_strains_on_compound_id", using: :btree
  add_index "compound_strains", ["strain_id"], name: "index_compound_strains_on_strain_id", using: :btree

  create_table "compounds", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conditions", force: :cascade do |t|
    t.binary   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conditions_strains", id: false, force: :cascade do |t|
    t.integer "strain_id",    null: false
    t.integer "condition_id", null: false
  end

  add_index "conditions_strains", ["condition_id"], name: "index_conditions_strains_on_condition_id", using: :btree
  add_index "conditions_strains", ["strain_id"], name: "index_conditions_strains_on_strain_id", using: :btree

  create_table "descriptive_answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "descriptive_questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disease_medication_connections", force: :cascade do |t|
    t.integer  "disease_id"
    t.integer  "medication_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "disease_medication_connections", ["disease_id"], name: "index_disease_medication_connections_on_disease_id", using: :btree
  add_index "disease_medication_connections", ["medication_id"], name: "index_disease_medication_connections_on_medication_id", using: :btree

  create_table "disease_symptom_connections", force: :cascade do |t|
    t.integer  "disease_id"
    t.integer  "symptom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "disease_symptom_connections", ["disease_id"], name: "index_disease_symptom_connections_on_disease_id", using: :btree
  add_index "disease_symptom_connections", ["symptom_id"], name: "index_disease_symptom_connections_on_symptom_id", using: :btree

  create_table "diseases", force: :cascade do |t|
    t.integer  "condition_id"
    t.integer  "patient_id"
    t.date     "diagnosis_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "diseases", ["condition_id"], name: "index_diseases_on_condition_id", using: :btree
  add_index "diseases", ["patient_id"], name: "index_diseases_on_patient_id", using: :btree

  create_table "diseases_strains", force: :cascade do |t|
    t.integer "disease_id"
    t.integer "strain_id"
  end

  add_index "diseases_strains", ["disease_id"], name: "index_diseases_strains_on_disease_id", using: :btree
  add_index "diseases_strains", ["strain_id"], name: "index_diseases_strains_on_strain_id", using: :btree

  create_table "effects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "effects_strains", id: false, force: :cascade do |t|
    t.integer "strain_id", null: false
    t.integer "effect_id", null: false
  end

  create_table "entity_tag_connections", force: :cascade do |t|
    t.integer  "taggable_entity_id"
    t.string   "taggable_entity_type"
    t.integer  "tag_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "event_dependent_surveys", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "physician_id"
    t.integer  "time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "event_dependent_surveys", ["physician_id"], name: "index_event_dependent_surveys_on_physician_id", using: :btree
  add_index "event_dependent_surveys", ["survey_id"], name: "index_event_dependent_surveys_on_survey_id", using: :btree

  create_table "field_values", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "entity_id"
    t.string   "entity_type"
  end

  add_index "field_values", ["entity_id", "entity_type"], name: "index_field_values_on_entity_id_and_entity_type", using: :btree

  create_table "genetics", force: :cascade do |t|
    t.string   "name"
    t.integer  "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "genetics", ["patient_id"], name: "index_genetics_on_patient_id", using: :btree

  create_table "list_driven_answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
  end

  create_table "medications", force: :cascade do |t|
    t.binary   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "multiple_choice_answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "multiple_choice_questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.string   "message"
    t.integer  "status",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "category",       default: 0
  end

  add_index "notifications", ["recipient_id", "recipient_type"], name: "index_notifications_on_recipient_id_and_recipient_type", using: :btree
  add_index "notifications", ["sender_id", "sender_type"], name: "index_notifications_on_sender_id_and_sender_type", using: :btree

  create_table "options", force: :cascade do |t|
    t.string   "name"
    t.integer  "list_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
  end

  create_table "phenotypes", force: :cascade do |t|
    t.string   "name"
    t.integer  "variation_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "phenotypes", ["variation_id"], name: "index_phenotypes_on_variation_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "description"
    t.integer  "survey_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0
    t.string   "type"
    t.integer  "max_range"
    t.integer  "min_range"
    t.integer  "list_id"
    t.integer  "category",    default: 0
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "range_based_answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "requests", ["recipient_id"], name: "index_requests_on_recipient_id", using: :btree
  add_index "requests", ["sender_id"], name: "index_requests_on_sender_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selected_options", force: :cascade do |t|
    t.integer  "list_driven_answer_id"
    t.binary   "option"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "side_effects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "side_effects_strains", id: false, force: :cascade do |t|
    t.integer "strain_id",      null: false
    t.integer "side_effect_id", null: false
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "physician_id"
    t.integer  "day"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.float    "from_time"
    t.float    "to_time"
    t.string   "type",         default: "AvailableSlot"
    t.date     "date"
  end

  add_index "slots", ["physician_id"], name: "index_slots_on_physician_id", using: :btree

  create_table "strains", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "brand_name"
    t.string   "dosage"
  end

  add_index "strains", ["category_id"], name: "index_strains_on_category_id", using: :btree

  create_table "strains_symptoms", id: false, force: :cascade do |t|
    t.integer "strain_id",  null: false
    t.integer "symptom_id", null: false
  end

  create_table "survey_configurations", force: :cascade do |t|
    t.integer  "survey_id"
    t.date     "from_date"
    t.integer  "days"
    t.integer  "sender_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.time     "schedule_time"
    t.datetime "last_acknowledged"
  end

  add_index "survey_configurations", ["sender_id"], name: "index_survey_configurations_on_sender_id", using: :btree
  add_index "survey_configurations", ["survey_id"], name: "index_survey_configurations_on_survey_id", using: :btree

  create_table "survey_receipients", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "survey_type"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "survey_receipients", ["survey_id", "survey_type"], name: "index_survey_receipients_on_survey_id_and_survey_type", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "status",                   default: 0
    t.boolean  "treatment_plan_dependent", default: false
  end

  add_index "surveys", ["creator_id"], name: "index_surveys_on_creator_id", using: :btree

  create_table "symptoms", force: :cascade do |t|
    t.binary   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "tag_group_id"
  end

  create_table "template_data", force: :cascade do |t|
    t.string   "message"
    t.integer  "template_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "template_data", ["template_id"], name: "index_template_data_on_template_id", using: :btree

  create_table "templates", force: :cascade do |t|
    t.integer  "strain_id"
    t.integer  "creator_id"
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "access_level", default: 0
  end

  add_index "templates", ["creator_id"], name: "index_templates_on_creator_id", using: :btree
  add_index "templates", ["strain_id"], name: "index_templates_on_strain_id", using: :btree

  create_table "therapy_entity_connections", force: :cascade do |t|
    t.integer  "treatment_plan_therapy_id"
    t.integer  "associated_entity_id"
    t.string   "associated_entity_type"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "treatment_data", force: :cascade do |t|
    t.integer  "treatment_plan_therapy_id"
    t.integer  "intake_count",              default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "last_intake"
    t.datetime "last_reminded"
  end

  add_index "treatment_data", ["treatment_plan_therapy_id"], name: "index_treatment_data_on_treatment_plan_therapy_id", using: :btree

  create_table "treatment_plan_therapies", force: :cascade do |t|
    t.integer  "treatment_plan_id"
    t.integer  "strain_id"
    t.float    "dosage_quantity"
    t.string   "dosage_unit"
    t.string   "message"
    t.integer  "intake_timing"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "treatment_plan_version_records", force: :cascade do |t|
    t.integer  "user_survey_form_id"
    t.integer  "treatment_plan_id"
    t.integer  "treatment_plan_version"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "treatment_plans", force: :cascade do |t|
    t.integer  "patient_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title"
    t.integer  "creator_id"
    t.integer  "current_version", default: 0
  end

  add_index "treatment_plans", ["patient_id"], name: "index_treatment_plans_on_patient_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_survey_forms", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "state"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "sent_at"
    t.datetime "started_at"
    t.datetime "submitted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_survey_forms", ["receiver_id"], name: "index_user_survey_forms_on_receiver_id", using: :btree
  add_index "user_survey_forms", ["sender_id"], name: "index_user_survey_forms_on_sender_id", using: :btree
  add_index "user_survey_forms", ["survey_id"], name: "index_user_survey_forms_on_survey_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "",      null: false
    t.string   "encrypted_password",               default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "ethnicity"
    t.date     "birthdate"
    t.string   "uuid"
    t.string   "height",                           default: "0"
    t.integer  "weight",                           default: 0
    t.string   "provider",                         default: "email", null: false
    t.string   "uid",                              default: "",      null: false
    t.json     "tokens"
    t.integer  "verification_code"
    t.json     "verification_status",              default: {}
    t.integer  "status",                           default: 0
    t.string   "license_id"
    t.date     "expiry"
    t.string   "location"
    t.string   "country_code"
    t.integer  "phone_number",           limit: 8
    t.boolean  "chart_approved"
    t.integer  "privilege"
    t.integer  "preferred_device"
    t.string   "time_zone"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id", "invited_by_type"], name: "index_users_on_invited_by_id_and_invited_by_type", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

  create_table "variations", force: :cascade do |t|
    t.string   "name"
    t.string   "chromosome"
    t.integer  "position"
    t.string   "genotype"
    t.string   "maf"
    t.integer  "genetic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "variations", ["genetic_id"], name: "index_variations_on_genetic_id", using: :btree

  add_foreign_key "answers", "questions"
  add_foreign_key "careteam_memberships", "careteams"
  add_foreign_key "compound_strains", "compounds"
  add_foreign_key "compound_strains", "strains"
  add_foreign_key "disease_medication_connections", "diseases"
  add_foreign_key "disease_medication_connections", "medications"
  add_foreign_key "disease_symptom_connections", "diseases"
  add_foreign_key "disease_symptom_connections", "symptoms"
  add_foreign_key "diseases", "conditions"
  add_foreign_key "diseases_strains", "diseases"
  add_foreign_key "diseases_strains", "strains"
  add_foreign_key "questions", "surveys"
  add_foreign_key "strains", "categories"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_survey_forms", "surveys"
end
