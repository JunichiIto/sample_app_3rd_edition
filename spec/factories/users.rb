FactoryGirl.define do
  factory :user do
    factory :michael do
      name 'Michael Example'
      email 'michael@example.com'
      password_digest User.digest('password')
      admin true
      activated true
      activated_at Time.zone.now
    end

    factory :archer do
      name 'Sterling Archer'
      email 'duchess@example.gov'
      password_digest User.digest('password')
      activated true
      activated_at Time.zone.now
    end
    
    factory :lana do
      name 'Lana Kane'
      email 'hands@example.gov'
      password_digest User.digest('password')
      activated true
      activated_at Time.zone.now
    end
  end
end
