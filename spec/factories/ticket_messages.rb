#coding: utf-8

FactoryGirl.define do
  factory :ticket_message do
    ticket  {ticket}
    sender  {ticket.initiator}
    message "Ну и ок!"
  end
end
