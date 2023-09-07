class Product < ApplicationRecord
    paginates_per 10

    belongs_to :user
    has_many :transactions

    def self.ransackable_attributes(auth_object = nil)
        ["brand", "item_name"]
    end
    
    validates :item_name, :brand, :stock, :price, :description, presence: true  
end
