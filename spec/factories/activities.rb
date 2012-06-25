# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    name "An Activity"
    street "400 Massachusetts Ave NW"
    city "Washington"
    country "USA"
    phone "123-456-7899"
  end
end
