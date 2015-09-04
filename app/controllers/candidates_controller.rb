class CandidatesController < ApplicationController
  def show
    @candidate = Candidate.find(params[:id])
    results = []

    Candidate.all.each do |candidate|
      results << candidate.id
    end
    index = results.find_index(params[:id].to_i)
    results[index + 1].nil? ? @next_id = results.first : @next_id = results[index + 1]
    @previous_id = results[index - 1]
  end
end


