FactoryBot.define do
  factory :user do
    name { 'name' }
    email { 'test@sample.com' }
    password_digest { 'password' }
  end
end
