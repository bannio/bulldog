source 'https://rubygems.org'

# ruby "2.1.2"
# ruby "2.4.0"
ruby "2.7.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '4.1.7'
# gem 'rails', '5.0.7.2'
gem 'rails', '5.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# Use SCSS for stylesheets
gem 'sass-rails' #, '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' #, '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails' #, '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'select2-rails'
gem 'devise', '>= 4.7.1'
gem 'figaro'
gem 'prawn'
gem 'prawn-table'
gem 'kaminari'
gem 'groupdate'
gem 'chartkick'
# gem 'stripe'
gem 'stripe-rails'
gem 'mailchimp-api', '~> 2.0.5', require: 'mailchimp'
gem 'pundit'
gem 'aasm'
gem "paperclip" #, "~> 4.1"
# gem 'aws-sdk', '~> 3'
gem 'aws-sdk-s3', '~> 1'
gem 'cookies_eu'
gem 'newrelic_rpm'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# To try to fix possible conflicts between turbolinks and other libraries
# gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder' #, '~> 1.2'

gem 'bootstrap-sass' #, '~> 3.2.0.0' #'~> 3.1.1.0'

gem 'high_voltage'  # for static pages
# gem 'simple_form'  # removed 19/9/2014

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'email_spec'
  gem 'action_mailer_cache_delivery' #, '~> 0.3.7'
  gem 'stripe-ruby-mock' #, '~> 2.0.0' #'~> 1.10.1.7'
  # required to allow 'assigns' to be used in tests.
  gem 'rails-controller-testing'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "rails_layout"
  # gem 'sprockets_better_errors'    not 4.1 compatible
  gem "brakeman", :require => false
  gem "spring"
  gem 'rails_best_practices'
end

group :test, :development do
  gem 'rspec-rails' #, '~> 3.0.2'
  gem 'spring-commands-rspec'
  gem 'database_cleaner'
  # gem 'capybara','~> 2.0.1'         installed as part of cucumber-rails
  # gem 'factory_girl_rails' #, '~> 4.4.0'
  gem 'factory_bot_rails'
  gem 'launchy'
  # gem 'rack-mini-profiler'
  gem 'selenium-client'
  # gem "selenium-webdriver", '~> 2.43.0'
  gem "selenium-webdriver"
  gem 'simplecov', :require => false
  gem 'rb-fsevent', :require => false
  gem 'guard-rspec'
  gem "letter_opener"
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'
gem 'rack-timeout'

gem 'rails_12factor', group: :production

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
