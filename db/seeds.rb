# Account.destroy_all 
# User.destroy_all
# PlaidItem.destroy_all
# PlaidAccount.destroy_all

# one = Account.create() #account doesnt take any parameters

# anam = User.create({
#   account_id: one.id,
#   username: "anamsoomro",
#   password_digest: "abc",
#   email: "abc@gmail.com"
# })

# sik = User.create({
#   account_id: one.id,
#   username: "sikendershahid",
#   password_digest: "123",
#   email: "123@gmail.com"
# })

# anamPi = PlaidItem.create({
#   user_id: anam.id,
#   p_access_token: "item token from plaid",
#   p_item_id: "item id from plaid"
# })

# sikPi = PlaidItem.create({
#   user_id: sik.id,
#   p_access_token: "item token from plaid",
#   p_item_id: "item id from plaid"
# })

# anamPiChecking = PlaidAccount.create({
#   plaid_item_id: anamPi.id,
#   p_account_id: "account id from plaid",
#   p_name: "name from plaid",
#   p_mask: "title from plaid"
# })

# anamPiCredit = PlaidAccount.create({
#   plaid_item_id: anamPi.id,
#   p_account_id: "account id from plaid",
#   p_name: "name from plaid",
#   p_mask: "title from plaid"
# })

# sikPiChecking = PlaidAccount.create({
#   plaid_item_id: sikPi.id,
#   p_account_id: "account id from plaid",
#   p_name: "name from plaid",
#   p_mask: "title from plaid"
# })