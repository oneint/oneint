# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Application.find_or_create_by(name: 'Custom webhook')
Application.find_or_create_by(name: 'Mixpanel')
Application.find_or_create_by(name: 'Customer.io')
Application.find_or_create_by(name: 'Appsflyer')
Application.find_or_create_by(name: 'Segment')
Application.find_or_create_by(name: 'Taplytics')
user = User.find_by(email: 'test@test.com')
unless user
  user = User.new(email: 'test@test.com')
  user.password = 'privacy4you'
  user.save!
end