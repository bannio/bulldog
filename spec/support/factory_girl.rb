# spec/support/factory_girl.rb
RSpec.configure do |config|
  # additional factory_girl configuration

  # MOVED to database_cleaner to resolves some flickering tests
  # config.before(:suite) do
  #   FactoryBot.lint
  # end
end
