#coding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    name "Иван Петров"
    city_of_birth {create :city}
  end
end
