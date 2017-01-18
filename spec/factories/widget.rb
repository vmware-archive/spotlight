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

    trait :gcal_resource_widget do
      category { 'gcal_resource_widget' }
      access_token { 'access_token' }
      refresh_token { 'refresh_token' }
      resource_id { 'fake-resource-id' }
    end

    trait :openair_widget do
      category { 'openair_widget' }
      username { 'username' }
      password { 'password' }
      company { 'company' }
      client { 'client' }
      key { 'key' }
    end
  end
end
