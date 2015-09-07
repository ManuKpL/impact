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

    # Mots présents dans les bios des followers du candidat
    @topwords_bio = @candidate.topwords.where(data_type: "followers bios").first.words

    # Personnes retweetées le plus souvent par le candidat
    @users_retweeted_by_candidate = @candidate.topwords.where(data_type: "candidate retweeted").first.words

    # Hashtags présents dans les tweets du candidat
    @hashtags_in_candidate_tweets= @candidate.topwords.where(data_type: "hashtags").first.words



  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
end


