class PlaidItem < ApplicationRecord
  has_many :plaid_accounts
  belongs_to :user
end
