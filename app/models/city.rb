#coding: utf-8
class City < ActiveRecord::Base
  has_many :visits

  def city_information=(ci)
    s = self
    ci.map{|k,v|s.send("#{k}=", v)}
  end
end
