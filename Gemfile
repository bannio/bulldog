source 'https://rubygems.org'

ruby "2.1.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'select2-rails'
gem 'devise'
gem 'figaro'
gem 'prawn'
gem 'kaminari'
gem 'groupdate'
gem 'chartkick'
# gem 'stripe'
gem 'stripe-rails'
gem 'mailchimp-api', '~> 2.0.5', require: 'mailchimp'
gem 'pundit'
gem 'aasm'
gem "paperclip", "~> 4.1"
gem 'aws-sdk', '~> 1.5.7'
gem 'cookies_eu'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# To try to fix possible conflicts between turbolinks and other libraries
# gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bootstrap-sass', '~> 3.2.0.0' #'~> 3.1.1.0'

# gem 'high_voltage'  # for static pages
gem 'simple_form'
gem 'high_voltage'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'email_spec'
  gem 'action_mailer_cache_delivery', '~> 0.3.7'
  gem 'stripe-ruby-mock', '~> 1.10.1.7'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "rails_layout"
  gem 'sprockets_better_errors'
  gem "brakeman", :require => false
end

group :test, :development do
  gem 'rspec-rails', '~> 3.0.2'
  gem 'database_cleaner'
  # gem 'capybara','~> 2.0.1'         installed as part of cucumber-rails
  gem 'factory_girl_rails', '~> 4.4.0'
  gem 'launchy'
  # gem 'rack-mini-profiler'
  gem 'selenium-client'
  gem "selenium-webdriver", '~> 2.43.0'
  gem 'simplecov', :require => false
  gem 'rb-fsevent', :require => false
  gem 'guard-rspec'
  gem "letter_opener"
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

gem 'rails_12factor', group: :production

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
