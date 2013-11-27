require 'factory_girl'

FactoryGirl.define do

  factory :user do
    trait :with_auth_token do
      after(:create) do |user|
        user.reset_authentication_token!
      end
    end
  end

  factory :client, parent: :user do
    client true

  end
end