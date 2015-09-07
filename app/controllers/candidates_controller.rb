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

    # TOPWORDS
    # top words in candidates bios
    @topwords_bio = @candidate.topwords.where(data_type: "followers bios").first.words
    # top mentions in candidate tweets
    @top_candidate_mentions = @candidate.topwords.where(data_type: "mentions").first.words
    # top mentions in candidate retweets
    @top_rt_mentions = @candidate.topwords.where(data_type: "RT mentions").first.words
    # top users retweeted by candidate
    @users_retweeted_by_candidate = @candidate.topwords.where(data_type: "candidate retweeted").first.words
    # top hashtags in candidate tweets
    @hashtags_in_tweets = @candidate.topwords.where(data_type: "hashtags").first.words
    # Hashtags in candidate retweets
    @hashtags_in_retweets = @candidate.topwords.where(data_type: "RT hashtags").first.words

    # INTERACTIONS
    # retweets on candidate tweets
    @retweets = @candidate.interactions.where(data_type: "retweets").first

    @favoris = @candidate.interactions.where(data_type: "favorites").first

  end

  private
  # find candidate ID before each method
  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
end


