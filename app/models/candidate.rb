class Candidate < ActiveRecord::Base
  has_many :interactions
  has_many :topwords
end
