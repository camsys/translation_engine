require 'rake'
require 'active_record'
require 'migrations/create_translations.rb'

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

    connection = ActiveRecord::Base.connection

    if !ActiveRecord::Base.connection.table_exists? 'translations'
      connection.create_table :translations do |t|
        t.integer :locale_id
        t.integer :translation_key_id
        t.string :value
        t.timestamps
      end
    end
    if !ActiveRecord::Base.connection.table_exists? 'translation_keys'
      connection.create_table :translation_keys do |t|
        t.string :name
        t.timestamps
      end
    end
    if !ActiveRecord::Base.connection.table_exists? 'locales'
      connection.create_table :locales do |t|
        t.string :name
        t.timestamps
      end
    end

    CreateTranslations.up

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