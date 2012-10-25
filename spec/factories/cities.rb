#coding: utf-8
require 'csv'

FactoryGirl.define do
  factory :city do
    name "Moscow"
    local_name "Москва"
    state "Moscow"
    country "Russia"
    population 11514330
  end
end
