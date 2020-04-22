class CreatePlaidAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :plaid_accounts do |t|

      t.integer :plaid_item_id

      t.string :p_account_id
      t.string :p_name
      t.string :p_mask

      t.timestamps
    end
  end
end
