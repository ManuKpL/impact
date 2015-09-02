
def get_candidate(screen_name)
  candidate = $twitter.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{screen_name}")
end

candidates = []

candidates << get_candidate('vpecresse')
candidates << get_candidate('claudebartolone')
candidates << get_candidate('emmacosse')
candidates << get_candidate('wdesaintjust')
candidates << get_candidate('YannWehrling')
candidates << get_candidate('dupontaignan')

Candidate.destroy_all

parties = ['Les Républicains', 'Parti socialiste', 'EELV', 'Front national', 'Mouvement démocrate', 'Debout la France']

candidates.each_with_index do |candidate, index|
  candidates_attributes = [
    { name: candidate[:name],
      screen_name: candidate[:screen_name],
      description: candidate[:description],
      followers_count: candidate[:followers_count],
      following_count: candidate [:friends_count],
      listed: candidate[:listed_count],
      tweets_count: candidate[:statuses_count],
      account_creation: candidate[:created_at],
      picture: candidate[:profile_image_url_https].gsub('normal', '400x400'),
      party: parties[index]
    }
  ]
  candidates_attributes.each { |params| Candidate.create!(params) }
end


