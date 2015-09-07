class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show]

  def show
    results = []
    Candidate.all.each do |candidate|
      results << candidate.id
    end
    index = results.find_index(params[:id].to_i)
    results[index + 1].nil? ? @next_id = results.first : @next_id = results[index + 1]
    @previous_id = results[index - 1]

    # topwords
    @topwords_bio = @candidate.topwords.where(data_type: "followers bios").first.words

  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
end


