# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :family_deal do
    ls_id nil
    link "#"
    title "A Family Deal"
    long_title "A kick ass, amazing family deal"
    deal_type "family_deal"
    merchandise_type "merchandise"
    market_id "1"
    market_name "Washington"
    market_location "DC"
    featureType "merchandise"
    country_code "US"
    subtitle "Foo"
    image_url "http://foo.jpg"
    categories "Category1"
    address1 "1433 R St NW"
    city "Washington"
    state "DC"
    zip "20009"
    country "US"
  end
end