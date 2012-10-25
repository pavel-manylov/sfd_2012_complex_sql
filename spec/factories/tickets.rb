#coding: utf-8

FactoryGirl.define do
  factory :ticket do
    subject   "Усё поломалось"
    initiator {client}
  end
end
