namespace :candidates do

  desc 'requests Twitter API for candidates infos & seeds DB'
  task :seed => :environment do

    Candidate.destroy_all

    candidates_h = {
      vpecresse: 'Les Républicains',
      claudebartolone: 'Parti socialiste',
      emmacosse: 'EELV',
      wdesaintjust: 'Front national',
      yannwehrling: 'Mouvement démocrate',
      dupontaignan: 'Debout la France',
      chantal_jouanno: 'UDI',
      n_arthaud: "Lutte Ouvrière",
      delaruejc: "Liste des Usagers",
      aurelien_veron: "Parti Libéral Démocrate",
      plaurent_pcf: "Parti Communiste Français",
      sylvaindesmet: "Indépendant (EELV)"
    }

    def get_candidate(screen_name)
      candidate = $twitter.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{screen_name}")
    end

    candidates = []
    candidates_h.keys.each do |candidate|
      candidates << get_candidate(candidate)
    end

    true_names = ['Valérie Pécresse', 'Claude Bartolone', 'Emmanuelle Cosse', 'Wallerand de Saint-Just', 'Yann Wehrling', 'Nicolas Dupont-Aignan', 'Chantal Jouanno', 'Nathalie Arthaud', 'Jean-Claude Delarue', 'Aurélien Veron', 'Pierre Laurent', 'Sylvain De Smet']

    candidates.each_with_index do |candidate, index|
      Candidate.create({
        name: true_names[index],
        screen_name: candidate[:screen_name],
        description: candidate[:description],
        followers_count: candidate[:followers_count],
        following_count: candidate[:friends_count],
        listed: candidate[:listed_count],
        tweets_count: candidate[:statuses_count],
        account_creation: candidate[:created_at],
        picture: candidate[:profile_image_url_https].gsub('normal', '400x400'),
        party: candidates_h.values[index]
      })
    end
  end

  desc 'requests Twitter API for candidates infos & updates DB'
  task :update => :environment do

    candidates_h = {
      vpecresse: 'Les Républicains',
      claudebartolone: 'Parti socialiste',
      emmacosse: 'EELV',
      wdesaintjust: 'Front national',
      yannwehrling: 'Mouvement démocrate',
      dupontaignan: 'Debout la France',
      chantal_jouanno: 'UDI',
      n_arthaud: "Lutte Ouvrière",
      delaruejc: "Liste des Usagers",
      aurelien_veron: "Parti Libéral Démocrate",
      plaurent_pcf: "Parti Communiste Français",
      sylvaindesmet: "Indépendant (EELV)"
    }

    def get_candidate(screen_name)
      candidate = $twitter.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{screen_name}")
    end

    candidates = []
    candidates_h.keys.each do |candidate|
      candidates << get_candidate(candidate)
    end

    candidates.each do |candidate|
      c = Candidate.find_by(screen_name: candidate[:screen_name])
      c.update({
        screen_name: candidate[:screen_name],
        description: candidate[:description],
        followers_count: candidate[:followers_count],
        following_count: candidate[:friends_count],
        listed: candidate[:listed_count],
        tweets_count: candidate[:statuses_count],
        account_creation: candidate[:created_at],
        picture: candidate[:profile_image_url_https].gsub('normal', '400x400')
      })
    end
  end

end




