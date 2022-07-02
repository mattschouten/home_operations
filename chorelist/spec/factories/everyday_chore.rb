FactoryBot.define do
  factory :everyday_chore do
    assigned_to { "Lassie" }
    sequence(:name) { |n| "Rescue Timmy #{n}" }
  end
end
