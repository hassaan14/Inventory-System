class AddStockToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :stock, :integer
  end
end
