# MONEYMOON

Personal finance application for couples to track their financial health, spending habits and ooverall trends together.

Created using Ruby on Rails and the Plaid API.

## dependencies: 
```
gem install 
```

## database: 
to create database and tables
```
rails db:migrate
```

## plaid
to link financial institutions, [sign up with Plaid](https://dashboard.plaid.com/signup). 
in 'config/application.yml' store your client_id, secret and public_key.
```
CLIENT_ID: xxxxxxxxxxxxxxxxxxxxxxxx
SECRET: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
PUBLIC_KEY: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## running 
```
rails s
```
after running the server, you can now set up your [frontend](https://github.com/anamsoomro/moneymoon-frontend). 

