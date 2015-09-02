class Topword < ActiveRecord::Base
  belongs_to :candidate
  has_many :words
end
