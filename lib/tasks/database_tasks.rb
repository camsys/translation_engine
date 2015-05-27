require 'rake'
require 'active_record'

class Locale < ActiveRecord::Base
end

class TranslationKey < ActiveRecord::Base
end

namespace :translation_engine do

  desc "Run migrations to add locale and key tables then add foreign_keys to Translation table."
  task :implement_new_database_schema => :environment do

    binding.pry
    drop_locale_sql = "DROP TABLE locales"
    create_locale_sql = "DROP TABLE locales;CREATE TABLE locales (id integer, name character varying(255), created_at timestamp without time zone, updated_at timestamp without time zone);"
    ActiveRecord::Base.connection.execute(create_locale_sql) rescue nil
    create_keys_sql = "CREATE TABLE translation_keys (id integer, name character varying(255), created_at timestamp without time zone, updated_at timestamp without time zone);"
    ActiveRecord::Base.connection.execute(create_keys_sql) rescue nil
    Rake::Task["db:schema:dump"].invoke

  end

  desc "Load database translations from config/locales/moved-to-db/*.yml files (idempotent)"
  task :migrate_existing_translation_data do

  	Translation.all.each do |translation|
    	locale = Locale.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    	key = TranslationKey.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    end
    
  end

  desc "Load database translations from config/locales/moved-to-db/*.yml files (idempotent)"
  task :install_new_translation_data do
    Dir.glob('config/locales/moved-to-db/*').each do |file|
      puts "Loading locale file #{file}"
      I18n::Utility.load_locale file
    end
  end

end