class CreateTranslations < ActiveRecord::Migration
  def change
    begin
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
    rescue
    end
  end
end 