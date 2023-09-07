class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.float :price
      t.integer :product_id

      t.timestamps
    end
  end
end
