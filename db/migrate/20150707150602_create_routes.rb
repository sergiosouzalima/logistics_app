class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :origin_point
      t.string :destination_point
      t.integer :distance
      t.belongs_to :map, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
