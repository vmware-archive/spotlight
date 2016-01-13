FactoryGirl.define do
  factory :widget do
    title { Faker::Company.name }
    ci_widget

    trait :ci_widget do
      category 'ci_widget'
    end

    trait :with_default_dashboard do
      dashboard
    end
  end
end
