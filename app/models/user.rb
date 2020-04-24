class User < ApplicationRecord

  has_many :plaid_items
  # belongs_to :account

  has_secure_password

  # validates :password, presence: true, :on => :create
  # validates :password_confirmation, presence: true, :on => :create


end
