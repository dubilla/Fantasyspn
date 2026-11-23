class CreateSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :seasons do |t|
      t.string :name, null: false
      t.integer :start_year, null: false
      t.timestamps
    end
    add_index :seasons, :start_year, unique: true

    add_column :posts, :season_id, :bigint
  end
end
