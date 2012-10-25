#coding: utf-8
class Person < ActiveRecord::Base
  belongs_to :city_of_birth, :class_name=>"City"
  has_many :visits
end
