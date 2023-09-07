class Transaction < ApplicationRecord
    paginates_per 10

    belongs_to :product

    validates :transaction_type, :price, :stock, presence: true
end