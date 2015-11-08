class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @candidates = Candidate.order(:screen_name)
  end
end
