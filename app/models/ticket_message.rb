#coding: utf-8
class TicketMessage < ActiveRecord::Base
  belongs_to :sender, :polymorphic => true
  belongs_to :ticket

  scope :joins_sender, lambda{
    unless defined?(@joins_sender)
      #@joins_sender = Arel::Nodes::OuterJoin.new()
    end
    #@joins_sender
  }
end
