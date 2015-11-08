class CandidatesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :compare]
  before_action :set_candidate, only: :show

  def index
    search_candidate_params['name'].length > 0 ? (redirect_to candidate_path(Candidate.find(search_candidate_params['name']))) : (redirect_to root_path)
  end

  def show
    # NAVIGATION ARROWS
    results = []
    Candidate.order(:screen_name).each do |candidate|
      results << candidate.id
    end
    index = results.find_index(@candidate.id)
    results[index + 1].nil? ? @next_candidate = Candidate.find(results.first) : @next_candidate = Candidate.find(results[index + 1])
    @previous_candidate = Candidate.find(results[index - 1])

    # TOPWORDS
    # top words in candidates bios
    @topwords_bio = @candidate.topwords.where(data_type: "followers bios").first.words.reverse
    # top mentions in candidate tweets
    @top_candidate_mentions = @candidate.topwords.where(data_type: "mentions").first.words.reverse
    # top mentions in candidate retweets
    @top_rt_mentions = @candidate.topwords.where(data_type: "RT mentions").first.words.reverse
    # top users retweeted by candidate
    @users_retweeted_by_candidate = @candidate.topwords.where(data_type: "candidate retweeted").first.words.reverse
    # top hashtags in candidate tweets
    @hashtags_in_tweets = @candidate.topwords.where(data_type: "hashtags").first.words.reverse
    # Hashtags in candidate retweets
    # @hashtags_in_retweets = @candidate.topwords.where(data_type: "RT hashtags").first.words

    # INTERACTIONS
    # retweets on candidate tweets
    @retweets_on_candidate = @candidate.interactions.where(data_type: "retweets").first
    # favs on candidate tweets
    @favorites_on_candidate = @candidate.interactions.where(data_type: "favorites").first
    # candidate retweets
    @candidate_retweets = @candidate.interactions.where(data_type: "candidate retweets").first
    # followers of candidate's followers
    @followers_followers = @candidate.interactions.where(data_type: "followers followers").first
    # lists that contain the candidate followers
    @lists_containing_followers = @candidate.interactions.where(data_type: "followers listed").first
    # followers tweets
    @followers_tweets = @candidate.interactions.where(data_type: "followers tweets").first
    # followers followings
    @followers_followings = @candidate.interactions.where(data_type: "followers followings").first
  end

  def compare
    @candidates = Candidate.all
    #tableau retweets/favorites
    @data_retweets_favorites = @candidates.map do |c|
      { retweets: c.interactions.where(data_type: "retweets").first.average,
        favorites: c.interactions.where(data_type: "favorites").first.average,
        followers: c.followers_count,
        name: c.name,
        id: c.id
      }
    end

    @data_followers_followers = @candidates.map do |c|
      { followers_tweets: c.interactions.where(data_type: "followers tweets").first.average,
        followers_followers: c.interactions.where(data_type: "followers followers").first.average,
        name: c.name,
        id: c.id
      }
    end

    @data_followers_followings = @candidates.map do |c|
      { followers: c.followers_count,
        followings: c.following_count,
        name: c.name,
        id: c.id
      }
    end
  end

  private
  # find candidate ID before each method
  def set_candidate
    @candidate = Candidate.find_by_screen_name(params[:id])
  end

  def search_candidate_params
    params.require(:search).permit(:name)
  end
end


