FactoryBot.define do
  factory :chore do
    assigned_to { "Timmy" }
    sequence(:name) { |n| "Climb out of the well #{n}" }
  end
end
