require 'json'

JSON_FILEPATH = "app/data/json/claudebartolone_followers.json"
CANDIDATE_SCREEN_NAME = 'claudebartolone'

def open_json(filepath)
  JSON.parse(File.open(filepath).read).first.last
end

# get nb of followings for each follower
def extract_followings_counts
  followers = open_json(JSON_FILEPATH)
  followings_counts = []
  followers.each { |follower| followings_counts << follower["friends_count"]}
  return followings_counts
end

# get avg nb of followings
def avg_followings_counts
  followings_counts = extract_followings_counts
  return followings_counts.inject(:+) / followings_counts.length
end

# get percentage of followers with followings_count > 1000
def percent_followings_counts
  followers = open_json(JSON_FILEPATH)
  followings_counts = extract_followings_counts
  imp_followings_counts = followings_counts.select { |c| c > 1000 }
  percent_followings_counts = (imp_followings_counts.length.to_f / followers.length.to_f) * 100
  return percent_followings_counts.to_i
end

def create_interaction_instance
  candidate = Candidate.find_by_screen_name(CANDIDATE_SCREEN_NAME)
  Interaction.create!(data_type: "followers_followings", average: avg_followings_counts, percentage: percent_followings_counts, candidate_id: candidate.id)
end
