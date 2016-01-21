FactoryGirl.define do
  factory :widget do
    title { Faker::Company.name }
    height { DashboardConfig::DEFAULT_WIDGET_HEIGHT }
    width { DashboardConfig::DEFAULT_WIDGET_WIDTH }
    ci_widget

    trait :ci_widget do
      category 'ci_widget'
    end

    trait :with_default_dashboard do
      dashboard
    end
  end
end
