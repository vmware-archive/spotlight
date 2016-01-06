FactoryGirl.define do
  factory :widget do
    title { Faker::Company.name }
    type 'CiWidget'
  end

  factory :ci_widget, parent: :widget, class: 'CiWidget' do
  end
end
