#coding: utf-8
class Purchase < ActiveRecord::Base
  belongs_to :client
end
