require 'rake'
require 'active_record'

class Locale < ActiveRecord::Base

end

class TranslationKey < ActiveRecord::Base

end

class Translation < ActiveRecord::Base
  belongs_to :locale
  belongs_to :translation_key
end

namespace :translation_engine do

  desc "Run migrations to add locale and key tables then add foreign_keys to Translation table."
  task :implement_new_database_schema => :environment do

    create_locale_sql = "DROP TABLE IF EXISTS locales; CREATE TABLE locales (id serial, name varchar(255), created_at timestamp without time zone, updated_at timestamp without time zone);"
    execute_sql(create_locale_sql)
    set_primary_key_sql = "UPDATE locales SET id = nextval(pg_get_serial_sequence('locales','id'));"
    execute_sql(set_primary_key_sql) 
    set_primary_key_sql = "ALTER TABLE locales ADD PRIMARY KEY (id);"
    execute_sql(set_primary_key_sql) 

    create_keys_sql = "DROP TABLE IF EXISTS translation_keys; CREATE TABLE translation_keys (id serial, name varchar(255), created_at timestamp without time zone, updated_at timestamp without time zone);"
    execute_sql(create_keys_sql)
    set_primary_key_sql = "UPDATE translation_keys SET id = nextval(pg_get_serial_sequence('translation_keys','id'));"
    execute_sql(set_primary_key_sql)
    set_primary_key_sql = "ALTER TABLE translation_keys ADD PRIMARY KEY (id);"
    execute_sql(set_primary_key_sql) 

    add_foreign_keys_to_translations_sql = "ALTER TABLE translations ADD COLUMN locale_id integer, ADD COLUMN translation_key_id integer"
    execute_sql(add_foreign_keys_to_translations_sql)

    Rake::Task["db:schema:dump"].invoke

  end

  desc "Migrate existing locale and key information from Translations to Locales and TranslationKeys"
  task :migrate_existing_translation_data => :environment do

  	Translation.all.each_with_index do |translation,idx|
    	locale = Locale.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    	translation_key = TranslationKey.find_or_create_by!(name: translation.key)
    	translation.translation_key_id = translation_key.id
      translation.save
    end
    
  end

  desc "Migrate existing locale and key information from Translations to Locales and TranslationKeys"
  task :wipe_and_reload_from_arc_qa_data => :environment do

    Translation.destroy_all
    TranslationKey.destroy_all
    Locale.destroy_all

    directory = TranslationEngine::Engine.root.to_s + "/db/"
    filename = "#{directory}ARC-QA-Translation-Data-05-28.csv"

    CSV.foreach(filename, :headers => true) do |row|        

        row_hash = row.to_hash.except("id").except("locale")
        new_translation = Translation.create(row_hash)
        locale = Locale.find_or_create_by(:name => row["locale"])
        new_translation.locale_id = locale.id
        translation_key = TranslationKey.find_or_create_by(:name => row["key"])
        new_translation.translation_key_id = translation_key.id

        new_translation.save

    end
    
  end

  desc "Load database translations from config/locales/moved-to-db/*.yml files (idempotent)"
  task :install_new_translation_data => :environment do
    Dir.glob('config/locales/moved-to-db/*').each do |file|
      puts "Loading locale file #{file}"
      I18n::Utility.load_locale file
    end
  end

  def execute_sql(sql_param)
    begin
      ActiveRecord::Base.connection.execute(sql_param)
    rescue => error
      puts "Error executing sql: #{sql_param} ERROR IS: #{error.to_s}"
    end
  end

end