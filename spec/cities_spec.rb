#coding: utf-8
require 'spec_helper'

describe "complex sql queries [cities]" do
  include SpecHelper


  let(:known_cities){
    CSV.read("#{File.dirname(__FILE__)}/factories/cities.csv").map{|v| { :name => v[0],
                                                               :local_name => v[1],
                                                               :state => v[2],
                                                               :population => v[3].gsub(",","").to_i,
                                                               :country => v[4]
    }}
  }

  let(:cities){
    known_cities.map{|ci| FactoryGirl.create(:city, :city_information => ci)}
  }

  before{
    cities
  }

  let(:people){
    names = %w(Иван Пётр Борис)
    names.map{|name| names.map{|s|[name, "#{s}ов"]} }.flatten.map{|name|
      FactoryGirl.create(:person, :name=>"#{name[1]} #{name[0]}")
    }
  }

  let(:city_at){City.arel_table}
  let(:people_at){Person.arel_table}
  let(:visits_at){Visit.arel_table}

  it_should_behave_like "similar sql queries" do
    #Информация по всем городам
    let(:queries){
      {
          sql:
              City.find_by_sql(
                  "SELECT * FROM `cities`" # plain sql
              ),
          active_record:
              City.all,
          sql_by_arel:
              City.find_by_sql(
                  City.arel_table.project(Arel.star) # .to_sql -> SELECT * FROM `cities`
              )
      }
    }

    specify{
      queries[:sql].count.should == cities.count
    }
  end


  it_should_behave_like "similar sql queries" do
    # население областей (штатов) по населению входящих в них городов
    let(:queries){
      {
          sql:
              City.find_by_sql(
                  "SELECT `country`, `state`, sum(`population`) as `population` FROM `cities` GROUP BY `country`, `state`"
              ),
          active_record_bad:
              City.group(:country, :state).sum(:population).map{|k,v| {:country=>k[0], :state=>k[1], :population=>v}},
          active_record:
              City.select([:country, :state, "sum(`population`) as `population`"]).group(:country, :state),
          sql_by_arel:
              City.find_by_sql(
                  city_at.project(
                      city_at[:country], city_at[:state], city_at[:population].sum.as("population")
                  ).group(city_at[:country], city_at[:state])
              ),
          active_record_with_arel:
              City.select([:country, :state, city_at[:population].sum.as("population")]).group(:country, :state)
      }
    }

    specify{
      not_uniq = queries[:sql].map{|v| [v[:country], v[:state]]}
      uniq = not_uniq.uniq
      not_uniq.count.should == uniq.count
    }

    specify{
      queries[:sql].first.population.should > 0
    }

  end


  it_should_behave_like "similar sql queries" do
    #города, которые посещали люди, посетившие город X
    let(:visits){
      [
          FactoryGirl.create(:visit, :person=>people[0], :city=>cities[0]),
          FactoryGirl.create(:visit, :person=>people[0], :city=>cities[1]),
          FactoryGirl.create(:visit, :person=>people[1], :city=>cities[1]),
          FactoryGirl.create(:visit, :person=>people[2], :city=>cities[2]),
      ]
    }

    before{
      visits
    }

    let(:visits_at_1_al){ visits_at.alias("v1") }
    let(:visits_at_1){ Arel::SelectManager.new(ActiveRecord::Base).from(visits_at_1_al) }

    let(:visits_at_2_al){ visits_at.alias("v2") }
    let(:visits_at_2){ Arel::SelectManager.new(ActiveRecord::Base).from(visits_at_2_al) }

    let(:queries){
      {
          sql:
              City.find_by_sql(
                  "SELECT * FROM `cities`
                   WHERE `cities`.`id` IN (
                     SELECT `v1`.`city_id` FROM `visits` as `v1` WHERE `v1`.`person_id` IN(
                       SELECT `v2`.`person_id` FROM `visits` as `v2` WHERE `city_id` = #{cities[1].id}
                     )
                   )"
              ),
          active_record:
              City.where(
                  :id => Visit.select(:city_id).where(
                                                        :person_id => Visit.select(:person_id).where(:city_id=>cities[1].id)
                  )
              ),
          sql_by_arel:
              City.find_by_sql(
                city_at.project(Arel.star).where(
                  city_at[:id].in(
                    visits_at_1.project(visits_at_1_al[:city_id]).where(
                      visits_at_1_al[:person_id].in(
                        visits_at_2.project(visits_at_2_al[:person_id]).where(
                          visits_at_2_al[:city_id].eq(cities[1].id)
                        )
                      )
                    )
                  )
                )
              )
      }
    }

    specify{
      queries[:sql].should =~ [cities[0], cities[1]]
    }
  end


  #TODO Arel::SelectManager.new(a).from(b)  -> Arel::SelectManager.new(a, b)

  # > Arel::SelectManager.new(at.engine).from([at.alias("bla"), at.alias("aaa")]).project(at.alias("aaa")[Arel::SqlLiteral.new("*")]).to_sql
  # => "SELECT `aaa`.`*` FROM `cities` `bla`, `cities` `aaa` "


end