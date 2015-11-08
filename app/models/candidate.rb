class Candidate < ActiveRecord::Base
  has_many :interactions
  has_many :topwords
  has_many :twitterdata
  has_many :words, through: :topwords

  def to_param
    screen_name
  end
end
