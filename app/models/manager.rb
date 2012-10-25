#coding: utf-8
class Manager < ActiveRecord::Base
  has_many :ticket_messages, :as=>:sender
end
