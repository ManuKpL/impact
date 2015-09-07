class PagesController < ApplicationController
  autocomplete :candidate, :name, full: true, limit: 15

  def home
    @candidates = Candidate.all
  end
end
