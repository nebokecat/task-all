# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "test",
  email: "test@test.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)
User.create!(
  name: "test2",
  email: "test2@test2.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)

Task.create!(
  name: 'task1',
  description: 'this is task1',
  finished_at: DateTime.new(2021,10,12),
  user_id: 1
)

Task.create!(
  name: 'task2',
  description: 'this is task2',
  finished_at: DateTime.new(2021,10,12),
  user_id: 2
)
