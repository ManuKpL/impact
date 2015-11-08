class PagesController < ApplicationController
  def home
    @candidates = Candidate.order(:screen_name)
  end
end
