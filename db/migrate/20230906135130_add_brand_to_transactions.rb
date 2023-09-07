class AddBrandToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :brand, :string
  end
end
