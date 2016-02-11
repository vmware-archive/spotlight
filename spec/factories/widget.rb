FactoryGirl.define do
  factory :widget do
    title { Faker::Company.name }
    height { DashboardConfig::DEFAULT_WIDGET_HEIGHT }
    width { DashboardConfig::DEFAULT_WIDGET_WIDTH }
    ci_widget

    position_x { 0 }
    position_y { 0 }

    trait :ci_widget do
      category 'ci_widget'
    end

    trait :with_default_dashboard do
      dashboard
    end

    trait :gcal_widget do
      category { 'gcal_widget' }
      access_token { 'access_token' }
      refresh_token { 'refresh_token' }
      calendar_id { 'office_calendar' }
    end
  end
end
