class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :maps, :name, unique: true
  end
end
