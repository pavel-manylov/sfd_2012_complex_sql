#coding: utf-8
class Ticket < ActiveRecord::Base
  belongs_to :client
  belongs_to :initiator, :polymorphic => true
  has_many :ticket_messages
end
