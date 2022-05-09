source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '4.2.5.1'

# Sass CSS compiler
gem 'sass-rails', '~> 5.0'

# Minification of Javascript
gem 'uglifier', '>= 1.3.0'

# For Coffeescript adaption
gem 'coffee-rails', '~> 4.1.0'

# For jQuery usage
gem 'jquery-rails'

gem "pgcrypto", :git => 'git://github.com/BlinkerGit/pgcrypto.git'

# For React Js
gem 'react-rails', '~> 1.6.2'

gem 'jbuilder', '~> 2.0'
gem 'puma'
gem 'bootstrap-sass'
gem 'devise'
gem 'devise_invitable'

gem 'sinatra', :require => false

# Token Authentication for APIs
gem 'devise_token_auth'

# Dependency of Token authentication
gem 'omniauth'

# For JSON serialization
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', ref: 'e185becd5d007da2f951d1f88c8872a2deb929e5'

# For Environment based Configuration
gem 'figaro'

# For sending SMS
gem 'twilio-ruby'

# For background processing
gem 'sidekiq'

gem 'pg'

# For Version Tracking of records
gem 'audited-activerecord'

# Console pretty print ... run commands w/ "ap <command>"
gem "awesome_print", require:"ap"

gem 'twitter-bootstrap-rails'

# Charts
gem 'chartkick'

# For passing data Rails -> Javascripts
gem 'gon'

# QR Codes
gem 'rqrcode'

# cancan
gem 'cancan'

# For Icons
gem "font-awesome-rails"

# For performing taks periodically
gem 'sidetiq'

# Rails admin 'Rollincode' Theme
gem 'rails_admin_rollincode', '~> 1.0'

# For generating Admin Dashboard
gem 'rails_admin'

# For making proper Transitions between states
gem 'state_machine'

# For updating the client on changes in server
gem "private_pub"

group :development, :test do

  # For debugging
  gem 'byebug'
  gem 'pry'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'rails_layout'

  # Library to mock emails
  gem "letter_opener" , '~>1.4.1'

  # For best practises in code
  gem 'rails_best_practices'

  # For security vulnerability check
  gem 'brakeman', :require => false
end

group :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'rspec-sidekiq'
  gem 'timecop'
end

group :production do
  gem 'rails_12factor'
end
