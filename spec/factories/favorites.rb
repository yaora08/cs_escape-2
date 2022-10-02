FactoryBot.define do
  factory :favorite do
    association :micropost
    association :user
  end
end
