class User < ApplicationRecord

  has_many :plaid_items
  belongs_to :account

  has_secure_password

  validates :username, uniqueness: true

  validate :check_empty_space

  def check_empty_space
    if self.username.match(/\s+/)
      errors.add(:username, "cannot contain empty spaces, please try again.")
    end
  end


  # validates :password, presence: true, :on => :create
  # validates :password_confirmation, presence: true, :on => :create


end
