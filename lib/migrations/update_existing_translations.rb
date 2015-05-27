class CreateTranslations < ActiveRecord::Migration
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

    Translation.all.each do |translation|
    	locale = Locale.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    	key = TranslationKey.find_or_create_by!(name: translation.locale)
    	translation.locale_id = locale.id
    end

  end
end