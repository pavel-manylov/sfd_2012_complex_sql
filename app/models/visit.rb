#coding: utf-8
class Visit < ActiveRecord::Base
  belongs_to :city
  belongs_to :person
end
