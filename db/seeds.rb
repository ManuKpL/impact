# require './app/data/extract/candidate_retweeted'
# require './app/data/extract/find_top_words'
# require './app/data/extract/followers_list_infos'
# require './app/data/extract/tweets_list_infos'

# Candidate.destroy_all
# Word.destroy_all
# Topword.destroy_all
# Interaction.destroy_all

# candidats à récupérer

# candidates_h = {
#   vpecresse: 'Les Républicains',
#   claudebartolone: 'Parti socialiste',
#   emmacosse: 'EELV',
#   wdesaintjust: 'Front national',
#   yannwehrling: 'Mouvement démocrate',
#   dupontaignan: 'Debout la France',
#   chantal_jouanno: 'UDI',
#   n_arthaud: "Lutte Ouvrière",
#   delaruejc: "Liste des Usagers",
#   aurelien_veron: "Parti Libéral Démocrate",
#   plaurent_pcf: "Parti Communiste Français",
#   sylvaindesmet: "Indépendant (EELV)"
# }

# # récupère les infos du candidat sur Twitter

# def get_candidate(screen_name)
#   candidate = $twitter.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{screen_name}")
# end

# candidates = []
# candidates_h.keys.each do |candidate|
#   candidates << get_candidate(candidate)
# end

# candidates.each_with_index do |candidate, index|
#   candidates_attributes = [
#     { name: candidate[:name],
#       screen_name: candidate[:screen_name],
#       description: candidate[:description],
#       followers_count: candidate[:followers_count],
#       following_count: candidate [:friends_count],
#       listed: candidate[:listed_count],
#       tweets_count: candidate[:statuses_count],
#       account_creation: candidate[:created_at],
#       picture: candidate[:profile_image_url_https].gsub('normal', '400x400'),
#       party: candidates_h.values[index]
#     }
#   ]
#   candidates_attributes.each { |params| Candidate.create!(params) }
# end


# Extraction des informations des JSON

# screen_names = %w(claudebartolone)
# screen_names.each do |candidate_screen_name|

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'retweets',
#     at_least: 10
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'favorites',
#     at_least: 5
#   }).run

#   ExtractCandidateRetweeted.new({
#     screen_name: candidate_screen_name,
#     data_type: 'candidate retweets'
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'RT retweets',
#     at_least: 10
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'RT favorites',
#     at_least: 5
#   }).run

#   ExtractFollowersListInfo.new({
#     screen_name: candidate_screen_name,
#     data_type: 'followers followers',
#     at_least: 1000
#   }).run

#   ExtractFollowersListInfo.new({
#     screen_name: candidate_screen_name,
#     data_type: 'followers listed',
#     at_least: 20
#   }).run

#   ExtractFollowersListInfo.new({
#     screen_name: candidate_screen_name,
#     data_type: 'followers tweets',
#     at_least: 2000
#   }).run

#   ExtractFollowersListInfo.new({
#     screen_name: candidate_screen_name,
#     data_type: 'followers followings',
#     at_least: 1000
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'mentions',
#     top_size: 20
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'RT mentions',
#     top_size: 20
#   }).run

#   FindTopWords.new({
#     screen_name: candidate_screen_name,
#     data_type: 'words',
#     content_type: 'tweet',
#     top_size: 20
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'hashtags',
#     top_size: 20
#   }).run

#   ExtractTweetsListInfos.new({
#     screen_name: candidate_screen_name,
#     data_type: 'RT hashtags',
#     top_size: 20
#   }).run

#   ExtractCandidateRetweeted.new({
#     screen_name: candidate_screen_name,
#     data_type: 'candidate retweeted',
#     content_type: 'screen_name',
#     top_size: 20
#   }).run

#   FindTopWords.new({
#     screen_name: candidate_screen_name,
#     data_type: 'followers bios',
#     content_type: 'follower',
#     top_size: 20
#   }).run
# end
