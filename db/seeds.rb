
def get_candidate(screen_name)
  candidate = $twitter.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{screen_name}")
end

candidates = []

candidates << get_candidate('vpecresse')
candidates << get_candidate('claudebartolone')

Candidate.destroy_all

candidates.each do |candidate|
  candidates_attributes = [
    { name: candidate[:name],
      screen_name: candidate[:screen_name],
      description: candidate[:description],
      followers_count: candidate[:followers_count],
      following_count: candidate [:friends_count],
      listed: candidate[:listed_count],
      tweets_count: candidate[:statuses_count],
      account_creation: candidate[:created_at],
      picture: candidate[:profile_image_url_https].gsub('normal', '400x400')
    }
  ]
  candidates_attributes.each { |params| Candidate.create!(params) }
end


