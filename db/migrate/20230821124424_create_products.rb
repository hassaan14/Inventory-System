class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :item_name
      t.string :brand
      t.integer :stock
      t.float :price
      t.text :description
      t.references :user

      t.timestamps
    end
  end
end
