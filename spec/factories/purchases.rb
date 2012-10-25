#coding: utf-8
FactoryGirl.define do
  factory :purchase do
    client          {client}
    sum             500
    payment_system  "paypal"
  end
end
