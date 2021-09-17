FactoryBot.define do
  # factory :task do
  #   sequence(:name) { |n| "TEST_NAME#{n}" }
  #   sequence(:description) { |n| "TEST_TEXT#{n}" }
  # end
  factory :task do
    id do 1 end
    name do 'string' end
    description do 'desc' end
  end
end
