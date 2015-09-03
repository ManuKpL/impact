require 'json'

JSON_FILEPATH = "app/data/json/claudebartolone_followers.json"

def open_json(filepath)
  JSON.parse(File.open(filepath).read).first.last
end

# NB OF TWEETS for each follower
def extract_tweets_counts
  followers = open_json(JSON_FILEPATH)
  tweets_counts = []
  followers.each { |follower| tweets_counts << follower["statuses_count"]}
  return tweets_counts
end

# get avg nb of tweets
def avg_tweets_count
  tweets_counts = extract_tweets_counts
  return tweets_counts.inject(:+) / tweets_counts.length
end

# get percentage of followers with tweet_count > 2000
def percent_tweets_counts
  followers = open_json(JSON_FILEPATH)
  tweets_counts = extract_tweets_counts
  imp_tweets_counts = tweets_counts.select { |c| c > 2000 }
  percent_tweets_counts = (imp_tweets_counts.length.to_f / followers.length.to_f) * 100
  return percent_tweets_counts.to_i
end

def create_interaction_instance
  candidate = Candidate.find_by_screen_name(CANDIDATE_SCREEN_NAME)
  Interaction.create!(data_type: "followers_tweets", average: avg_tweets_count, percentage: percent_tweets_counts, candidate_id: candidate.id)
end
