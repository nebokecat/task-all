FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:description) { |n| "TEST_TEXT#{n}" }
  end
end
