require 'rake'

class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :locale_id
      t.string :key_id
      t.string :value
      t.timestamps
    end
    create_table :keys do |t|
    	t.string name
    	t.timestamps
    end
    create_table :locales do |t|
    	t.string name
    	t.timestamps
    end
  end
end

class UpdateExistingTranslations < ActiveRecord::Migration

  def change

  	#Create new tables
  	create_table :translation_keys do |t|
    	t.string name
    	t.timestamps
    end
    create_table :locales do |t|
    	t.string name
    	t.timestamps
    end

    class Locale < ActiveRecord::Base
  	end

  	class TranslationKey < ActiveRecord::Base
  	end

	add_column :translations, :locale_id, :integer
    add_column :translations, :key_id, :integer

  end

end

namespace :translation_engine do

  desc "Load database translations from config/locales/moved-to-db/*.yml files (idempotent)"
  task migrate_existing_translation_data do

  	Translation.all.each do |translation|
    	locale = Locale.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    	key = TranslationKey.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    end
    
  end

  desc "Load database translations from config/locales/moved-to-db/*.yml files (idempotent)"
  task install_new_translation_data do
    Dir.glob('config/locales/moved-to-db/*').each do |file|
      puts "Loading locale file #{file}"
      I18n::Utility.load_locale file
    end
  end

end