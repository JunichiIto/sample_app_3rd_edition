FactoryGirl.define do
  factory :relationship do
    factory :one do
      association :follower, factory: :michael
      association :followed, factory: :lana
    end
    factory :two do
      association :follower, factory: :michael
      association :followed, factory: :mallory
    end
    factory :three do
      association :follower, factory: :lana
      association :followed, factory: :michael
    end
    factory :four do
      association :follower, factory: :archer
      association :followed, factory: :michael
    end
  end
end
