namespace :followers do

  desc 'open JSON and create followers instances'
  task :seed do

    def open_json
      JSON.parse(File.open(@file_path).read).first.last
    end

    candidates = %w(claudebartolone emmacosse wdesaintjust YannWehrling Chantal_Jouanno n_arthaud DelarueJC aurelien_veron plaurent_pcf SylvainDeSmet)
    candidates.each_with_index do |screen_name, index|
      start = Time.now
      @file_path = "app/data/json/#{screen_name.downcase}_followers.json"
      candidate = Candidate.find_by_screen_name(screen_name)
      open_json.each do |tweet|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "follower", id_twitter: tweet['id_str'])
        twitterdatum.data = twitterdatum.encode_data(tweet)
        twitterdatum.save
      end
      stop = Time.now
      p "done! #{index} - #{candidate.name} (#{stop - start} s)"
    end
  end

end
