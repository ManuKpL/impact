class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show]

  def show
    # navigation arrows
    results = []
    Candidate.all.each do |candidate|
      results << candidate.id
    end
    index = results.find_index(params[:id].to_i)
    results[index + 1].nil? ? @next_id = results.first : @next_id = results[index + 1]
    @previous_id = results[index - 1]

    # most frequent words in candidates bios
    @topwords_bio = @candidate.topwords.where(data_type: "followers bios").first.words

    # most frequent words in candidate tweets
    @topwords_candidate_tweets = @candidate.topwords.where(data_type: "words").first.words
    raise

    # users most retweeted by candidate
    @users_retweeted_by_candidate = @candidate.topwords.where(data_type: "candidate retweeted").first.words

    # Hashtags in candidate tweets
    @hashtags_in_tweets = @candidate.topwords.where(data_type: "hashtags").first.words

    # Hashtags in candidate retweets
    # @hashtags_in_retweets = @candidate.topwords.where(data_type: "RT hashtags").first.words



  end

  private
  # find candidate ID before each method
  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
end


