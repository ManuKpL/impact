namespace :tweets do

  desc 'open JSON and create tweets instances'
  task :seed => :environment do

    def open_json
      JSON.parse(File.open(@file_path).read).first.last
    end

    Candidate.all.each_with_index do |candidate, index|
      start = Time.now
      @file_path = "app/data/json/#{candidate.screen_name.downcase}_tweets.json"
      open_json.each do |tweet|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "tweet", id_twitter: tweet['id_str'])
        twitterdatum.data = twitterdatum.encode_data(tweet)
        twitterdatum.save
      end
      stop = Time.now
      p "done! #{index} - #{candidate.name} (#{stop - start} s)"
    end
  end

end
