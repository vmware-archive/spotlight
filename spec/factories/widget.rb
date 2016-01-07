FactoryGirl.define do
  factory :widget do
    title { Faker::Company.name }
    type 'CiWidget'

    trait :with_default_dashboard do
      dashboard
    end
  end

  factory :ci_widget, parent: :widget, class: 'CiWidget' do
  end
end
