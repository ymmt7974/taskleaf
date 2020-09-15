# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :ja

# ユーザー
User.create!(name:  "admin",
             email: "admin@example.com",
             password:              "admin",
             password_confirmation: "admin",
             admin: true)

10.times do |n|
 name  = "user#{n+1}"
 email = "user#{n+1}@example.com"
 password = "password"
 User.create!(name:  name,
             email: email,
             password:              password,
             password_confirmation: password)
end


# タスク
admin = User.find_by(name: "admin")
10.times do |n|
  description = Faker::Lorem.sentence
  admin.tasks.create!(name: "タスク#{n}", description: description)
end
