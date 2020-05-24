class DropPlaidAccountsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :plaid_accounts
  end
end
