#coding: utf-8
class Client < ActiveRecord::Base
  has_many :tickets, :as=>:initiator
  has_many :ticket_messages, :as=>:sender

  has_many :purchases

  scope :joins_purchase, lambda{
    unless defined?(@joins_purchase)
      p = Purchase.arel_table
      @joins_purchase = joins(Arel::OuterJoin.new(p, Arel::Nodes::On.new(arel_table[:id].eq(p[:client_id])))).group(p[:client_id])
    end
    @joins_purchase
  }

  scope :with_purchases_count, lambda{
    joins_purchase.add_select(Purchase.arel_table[:id].count.as("purchases_count"))
  }

  scope :with_spent_money, lambda{
    joins_purchase.add_select(Purchase.arel_table[:sum].sum.as("spent_money"))
  }

  scope :with_purchases_information, lambda{
    with_purchases_count.with_spent_money
  }
end
