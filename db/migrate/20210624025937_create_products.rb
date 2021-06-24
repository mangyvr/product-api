class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description
      t.integer :view_count, null: false, default: 0, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
