class Topword < ActiveRecord::Base
  belongs_to :candidate
  has_many :words, dependent: :destroy
end
