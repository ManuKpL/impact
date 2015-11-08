class Candidate < ActiveRecord::Base
  has_many :interactions
  has_many :topwords
  has_many :twitterdata
  has_many :words, through: :topwords

  def to_param
    screen_name
  end

  # ATTENTION: method find() overwritten for this model >> find()> find_by_id() // find_by_screen_name() >> find()
  def self.find(param)
    find_by_screen_name(param)
  end
end
