class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.references :league
      t.string :player
      t.string :team
      t.string :pos
      t.integer :att
      t.float :attg
      t.integer :yds
      t.float :avg
      t.float :ydsg
      t.integer :td
      t.integer :lng
      t.boolean :lng_t
      t.integer :first
      t.float :first_percent
      t.integer :twenty_plus
      t.integer :forty_plus
      t.integer :fum
      t.timestamps
    end
  end
end
