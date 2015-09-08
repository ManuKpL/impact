class Candidate < ActiveRecord::Base
  has_many :interactions
  has_many :topwords
  has_many :twitterdata
  has_many :words, through: :topwords
end
