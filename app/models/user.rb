class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :products
  has_many :transactions, through: :products

  # validates :name, :phone, presence: true
  # validates :name, length: {minimum:2, maximum:15}
  validates :email, uniqueness: true
end
