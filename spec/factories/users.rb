# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "#{ADMIN_EMAIL}"
    password "hungry"
  end
end
