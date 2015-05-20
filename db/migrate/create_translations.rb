class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :locale_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end