require 'json'

JSON_FILEPATH = "app/data/json/claudebartolone_followers.json"

def open_json(filepath)
  JSON.parse(File.open(filepath).read).first.last
end

# get followers_count for each follower
def extract_followers_counts
  followers = open_json(JSON_FILEPATH)
  followers_counts = []
  followers.each { |follower| followers_counts << follower["followers_count"] }
  return followers_counts
end

# get average nb of followers
def avg_followers
  followers_counts = extract_followers_counts
  return followers_counts.inject(:+) / followers_counts.length
end

# get percentage of followers_count >1000
def percent_followers_counts
  followers = open_json(JSON_FILEPATH)
  followers_counts = extract_followers_counts
  imp_followers = followers_counts.select { |c| c >= 1000 }
  percent_followers_counts = (imp_followers.length.to_f / followers.length.to_f) * 100
  return percent_followers_counts.to_i
end

def create_interaction_instance
  candidate = Candidate.find_by_screen_name(CANDIDATE_SCREEN_NAME)
  Interaction.create!(data_type: "followers_followers", average: avg_followers, percentage: percent_followers_counts, candidate_id: candidate.id)
end
