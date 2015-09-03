require 'json'

# filepaths
json_filepath = "db/json/bartolone_followers.json"

# get array of followers hashes
followers = JSON.parse(File.open(json_filepath).read).first.last

# NB OF TWEETS

# get nb of tweets for each follower
tweets_counts = []
followers.each { |follower| tweets_counts << follower["statuses_count"]}

# get avg nb of tweets
avg_tweet_count = tweets_counts.inject(:+) / tweets_counts.length

# get nb of followers with tweet_count > 2000
imp_tweets_counts = tweets_counts.select { |c| c > 2000 }
nb_imp_tweets_counts = imp_tweets_counts.length


# NB OF FOLLOWINGS

# get nb of followings for each follower
followings_counts = []
followers.each { |follower| followings_counts << follower["friends_count"]}

# get avg nb of followings
avg_followings_count = followings_counts.inject(:+) / followings_counts.length

# get nb of followers with followings_count > 1000
imp_followings_counts = followings_counts.select { |c| c > 1000 }
nb_imp_followings_counts = imp_followings_counts.length

