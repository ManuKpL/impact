require 'json'

# filepaths
json_filepath = "app/data/json/bartolone_followers.json"

# get array of followers(hash)
followers = JSON.parse(File.open(json_filepath).read).first.last

# FOLLOWERS_COUNT

# get followers_count for each follower
followers_count = []
followers.each { |follower| followers_count << follower["followers_count"] }

# get average nb of followers
avg_followers = followers_count.inject(:+) / followers_count.length

# get important followers_count (>1000)
imp_followers = followers_count.select { |c| c >= 1000 }

# LISTED FOLLOWERS

# get nb of followers listed
listed_counts = []
followers.each do |follower|
  if follower["listed_count"] > 0
    listed_counts << follower["listed_count"]
  end
end
nb_listed_followers = listed_counts.length

# get avg nb of lists
avg_listed_count = listed_counts.inject(:+) / listed_counts.length

# get nb of followers belonging to more than 20 lists
imp_listed_followers = listed_counts.select { |c| c > 20 }
nb_imp_listed_followers = imp_listed_followers.length

