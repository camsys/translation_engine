class UpdateExistingTranslations < ActiveRecord::Migration
  def up

    #Create new tables
    create_table :translation_keys do |t|
      t.string name
      t.timestamps
    end
    create_table :locales do |t|
      t.string name
      t.timestamps
    end

    add_column :translations, :locale_id, :integer
    add_column :translations, :key_id, :integer

  end
end