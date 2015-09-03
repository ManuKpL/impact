class PagesController < ApplicationController
  def home
    @candidates = Candidate.all
  end
end
