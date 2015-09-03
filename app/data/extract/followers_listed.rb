require 'json'

JSON_FILEPATH = "app/data/json/claudebartolone_followers.json"

def open_json(filepath)
  JSON.parse(File.open(filepath).read).first.last
end

def extract_listed_counts
  followers = open_json(JSON_FILEPATH)
  listed_counts = []
  followers.each do |follower|
    if follower["listed_count"] > 0
      listed_counts << follower["listed_count"]
    end
  end
  return listed_counts
end

# get avg nb of lists
def avg_listed_counts
  listed_counts = extract_listed_counts
  return listed_counts.inject(:+) / listed_counts.length
end

# get percentage of followers belonging to more than 20 lists
def percent_listed_followers
  followers = open_json(JSON_FILEPATH)
  listed_counts = extract_listed_counts
  imp_listed_followers = listed_counts.select { |c| c > 20 }
  percent_listed_followers = (imp_listed_followers.length.to_f / followers.length.to_f) * 100
  return percent_listed_followers.to_i
end

def create_interaction_instance
  candidate = Candidate.find_by_screen_name(CANDIDATE_SCREEN_NAME)
  Interaction.create!(data_type: "followers_listed", average: avg_listed_counts, percentage: percent_listed_followers, candidate_id: candidate.id)
end


