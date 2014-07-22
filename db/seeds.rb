# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'CREATE PLAN'
@plan = Plan.create(name: 'Personal', amount: 2000)

puts 'SETTING UP DEMO USER LOGIN'
@user = User.create!(email: 'demo@example.com', 
    password: 'password', 
    password_confirmation: 'password',
    confirmed_at: Time.now)

@account = Account.create(name: 'Demo Account', user_id: @user.id, plan_id: @plan.id)

puts 'New user demo@example.com created. '
