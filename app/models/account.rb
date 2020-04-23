class Account < ApplicationRecord
  has_many :users
  has_many :plaid_items, through: :users
  
end
