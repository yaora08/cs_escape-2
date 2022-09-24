FactoryBot.define do
    factory :user, aliases: [:follower, :followed] do
      name { Faker::Name.name }
      sequence(:email) { |n| "test#{n}@example.com" }
      password { "foobar" }
      password_confirmation { "foobar" }
      activated { true }
      activated_at { Time.zone.now }
    
  
      trait :admin do
        admin { true }
      end
  
      trait :no_activated do
        activated { false }
        activated_at { nil }
      end
    end
end