# rack-timeout gem
# set to less than the unicorn timeout config

# Rack::Timeout.timeout = 10  # seconds
Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 10