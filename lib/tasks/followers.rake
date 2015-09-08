namespace :followers do

  desc 'open JSON and create followers instances'
  task :seed => :environment do

    def open_json
      JSON.parse(File.open(@file_path).read).first.last
    end

    candidates = %w(claudebartolone emmacosse wdesaintjust YannWehrling Chantal_Jouanno n_arthaud DelarueJC aurelien_veron plaurent_pcf SylvainDeSmet)
    candidates.each_with_index do |screen_name, index|
      start = Time.now
      @file_path = "app/data/json/#{screen_name.downcase}_followers.json"
      candidate = Candidate.find_by_screen_name(screen_name)
      open_json.reverse.each do |follower|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "follower", id_twitter: follower['id_str'])
        twitterdatum.data = twitterdatum.encode_data(follower)
        twitterdatum.save
      end
      stop = Time.now
      p "done! #{index} - #{candidate.name} (#{stop - start} s)"
    end
  end

  task :update => :environment do
    candidates = %w(claudebartolone emmacosse wdesaintjust YannWehrling Chantal_Jouanno n_arthaud DelarueJC aurelien_veron plaurent_pcf SylvainDeSmet)
    candidates.each do |screen_name|
      candidate = Candidate.find_by_screen_name(screen_name)
      ids = $twitter.follower_ids(candidate.screen_name).attrs[:ids].slice(0,590).reverse

      start = 0
      stop = start + 99
      ids_s = []
      while stop < ids.length
        ids_s << ids[start..stop].join(',')
        start = stop + 1
        stop = start + 99
      end
      stop = ids.length - 1
      ids_s << ids[start..stop].join(',')

      ids_s.each do |string|
        $twitter.get('https://api.twitter.com/1.1/users/lookup.json?user_id=' << string).each do |follower|
          twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "follower", id_twitter: follower[:id_str])
          twitterdatum.data = twitterdatum.encode_data(follower)
          twitterdatum.save
        end
      end
    end
  end
end

