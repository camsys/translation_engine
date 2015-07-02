require 'rake'
require 'active_record'

class Locale < ActiveRecord::Base
  self.primary_key = 'id'
end

class TranslationKey < ActiveRecord::Base
  self.primary_key = 'id'
end

class Translation < ActiveRecord::Base
  self.primary_key = 'id'
  #belongs_to :locale
  belongs_to :translation_key
  belongs_to :locale
end

namespace :translation_engine do

  desc "Create translation, translation_key, and locale tables"
  task :install => :environment do

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

  def execute_sql(sql_param)
    begin
      ActiveRecord::Base.connection.execute(sql_param)
    rescue => error
      puts "Error executing sql: #{sql_param} ERROR IS: #{error.to_s}"
    end
  end

end