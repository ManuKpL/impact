class CandidatesController < ApplicationController
  def show
    @candidate = Candidate.find(params[:id])
    ary = []
    Candidate.all.each do |candidate|
      ary << candidate.id
      # find id index for each candidate in array
      # this index is previous or next ary[index+1]
    end
    @next_id = params[:id] + 1
    @previous_id = params[:id] - 1
  end
end
