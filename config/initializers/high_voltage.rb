# config/initializers/high_voltage.rb
HighVoltage.configure do |config|
  config.home_page = 'home'  # renders app/views/pages/home.html.erb
  config.route_drawer = HighVoltage::RouteDrawers::Root  # removes /pages/.. from url
end