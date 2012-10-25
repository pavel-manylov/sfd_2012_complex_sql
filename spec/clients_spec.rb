#coding: utf-8
require 'spec_helper'

describe "complex sql queries [clients]" do
  include SpecHelper

  let(:clients){
    [
        FactoryGirl.create(:client, :name=>"Иван"),
        FactoryGirl.create(:client, :name=>"Борис")
    ]
  }

  let(:client_at){Client.arel_table}

  context "purchases" do
    let(:purchases){
      [
        FactoryGirl.create(:purchase, :client => clients[0], :sum=>200, :payment_system=>"visa"),
        FactoryGirl.create(:purchase, :client => clients[0], :sum=>100, :payment_system=>"visa"),
        FactoryGirl.create(:purchase, :client => clients[0], :sum=>500, :payment_system=>"paypal"),
        FactoryGirl.create(:purchase, :client => clients[0], :sum=>600, :payment_system=>"webmoney"),
        FactoryGirl.create(:purchase, :client => clients[1], :sum=>200, :payment_system=>"yandex"),
        FactoryGirl.create(:purchase, :client => clients[1], :sum=>400, :payment_system=>"paypal"),
        FactoryGirl.create(:purchase, :client => clients[0], :sum=>800, :payment_system=>"yandex"),
        FactoryGirl.create(:purchase, :client => clients[0], :sum=>1600, :payment_system=>"paypal"),
      ]
    }

    before{ purchases }

    let(:purchases_at){Purchase.arel_table}


    let(:purchases_join){
      Arel::OuterJoin.new(purchases_at, Arel::Nodes::On.new(client_at[:id].eq(purchases_at[:client_id])))
    }

    let(:client_with_purchases_count){
      Client.joins(purchases_join).add_select(purchases_at[:id].count.as("purchases_count")).group(purchases_at[:client_id])
    }

    let(:client_with_spent_money){
      Client.joins(purchases_join).add_select(purchases_at[:sum].sum.as("spent_money")).group(purchases_at[:client_id])
    }

    specify{
      pcc = purchases.collect{|p|p.client}.uniq.count
      client_with_purchases_count.all.count.should == pcc
      client_with_spent_money.all.count.should == pcc
    }

    specify{
      client_with_purchases_count.each do |i|
        i.attributes.keys.should =~ %w(id name created_at updated_at purchases_count)
      end
    }

    specify{
      client_with_spent_money.each do |i|
          i.attributes.keys.should =~ %w(id name created_at updated_at spent_money)
        end
      }

    shared_examples_for "with purchases_count" do
      specify{
        clients.each do |client|
          clients_to_check.find{|c|c.id==client.id}.purchases_count.should == purchases.select{|i| i.client == client}.count
        end
      }
    end

    it_should_behave_like "with purchases_count" do
      let(:clients_to_check){client_with_purchases_count}
    end

    shared_examples_for "with spent_money" do
      specify{
        clients.each do |client|
          clients_to_check.find{|c|c.id==client.id}.spent_money.should == purchases.select{|i| i.client == client}.inject(0){|p,c|p+c[:sum]}
        end
      }
    end

    it_should_behave_like "with spent_money" do
      let(:clients_to_check){client_with_spent_money}
    end

    specify{
      Client.with_purchases_count.should == client_with_purchases_count
    }

    specify{
      Client.with_spent_money.should == client_with_spent_money
    }

    it_should_behave_like "with purchases_count", "with spent_money" do
      let(:clients_to_check){Client.with_purchases_information}
    end
  end

  context "tickets" do
    let(:managers){
      [
          FactoryGirl.create(:manager, :name=>"Илларион"),
          FactoryGirl.create(:manager, :name=>"Григорий")
      ]
    }

    let(:ticket){
      FactoryGirl.create(:ticket, :initiator => clients.first)
    }

    let(:ticket_messages){
      [
          FactoryGirl.create(:ticket_message, :ticket=>ticket, :message=>"1", :sender=>clients.first),
          FactoryGirl.create(:ticket_message, :ticket=>ticket, :message=>"2", :sender=>managers.first),
          FactoryGirl.create(:ticket_message, :ticket=>ticket, :message=>"3", :sender=>clients.first),
          FactoryGirl.create(:ticket_message, :ticket=>ticket, :message=>"4", :sender=>managers.second)
      ]
    }

    let(:manager_at){ Manager.arel_table }
    let(:tm_at){ TicketMessage.arel_table }

    let(:sender_client_join){
      Arel::Nodes::OuterJoin.new(client_at, Arel::Nodes::On.new(client_at[:id].eq(tm_at[:sender_id]).and(tm_at[:sender_type].eq("Client"))))
    }

    let(:sender_manager_join){
      Arel::Nodes::OuterJoin.new(manager_at, Arel::Nodes::On.new(manager_at[:id].eq(tm_at[:sender_id]).and(tm_at[:sender_type].eq("Manager"))))
    }

    before{ticket_messages}

    specify{
      ticket.ticket_messages.joins(sender_client_join).joins(sender_manager_join) \
                            .add_select(Arel::Nodes::NamedFunction.new("IFNULL", [client_at[:name], manager_at[:name]]).as("sender_name")).each do |tm|
        tm.sender_name.should == tm.sender.name
      end
    }

  end
end