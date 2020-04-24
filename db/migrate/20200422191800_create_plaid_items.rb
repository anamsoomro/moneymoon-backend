class CreatePlaidItems < ActiveRecord::Migration[6.0]
  def change
    create_table :plaid_items do |t|

      t.integer :user_id 
      
      t.string :p_access_token
      t.string :p_item_id

      # t.timestamps
    end
  end
end
