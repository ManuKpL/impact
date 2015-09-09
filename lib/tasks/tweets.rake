namespace :tweets do

  desc 'open JSON and create tweets instances'
  task :seed => :environment do

    def open_json
      JSON.parse(File.open(@file_path).read).first.last
    end

    Candidate.all.each_with_index do |candidate, index|
      start = Time.now
      @file_path = "app/data/json/#{candidate.screen_name.downcase}_tweets.json"
      open_json.reverse.each do |tweet|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "tweet", id_twitter: tweet['id_str'])
        twitterdatum.data = twitterdatum.encode_data(tweet)
        twitterdatum.save
      end
      stop = Time.now
      p "done! #{index} - #{candidate.name} (#{stop - start} s)"
    end
  end

  desc 'add new tweets instances without JSON'
  task :update => :environment do
    Candidate.all.each do |candidate|
      tweet = Twitterdatum.where(data_type: "tweet").where(candidate_id: candidate.id).last
      results = $twitter.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{candidate.screen_name}&count=200&include_rts=1&since_id=#{tweet.id_twitter.to_i}")
      results.reverse.each do |tweet|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "tweet", id_twitter: tweet[:id_str])
        twitterdatum.data = twitterdatum.encode_data(tweet)
        twitterdatum.save
      end
    end
  end

  desc 'add new tweets instances to JSON'
  task :json => :environment do
    Candidate.all.each do |candidate|
      tweet = Twitterdatum.where(data_type: "tweet").where(candidate_id: candidate.id).last
      results = $twitter.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{candidate.screen_name}&count=200&include_rts=1&since_id=#{tweet.id_twitter.to_i}")
      results.reverse.each do |tweet|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "tweet", id_twitter: tweet[:id_str])
        twitterdatum.data = twitterdatum.encode_data(tweet)
        twitterdatum.save
      end
    end

    def open_json
      JSON.parse(File.open(@file_path).read).first.last
    end

    candidates = %w(claudebartolone emmacosse wdesaintjust YannWehrling Chantal_Jouanno n_arthaud DelarueJC aurelien_veron plaurent_pcf SylvainDeSmet)
    Candidate.all.each_with_index do |candidate, index|
      @start = Time.now
      @file_path = "app/data/json/#{candidate.screen_name.downcase}_tweets.json"
      results = $twitter.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{candidate.screen_name}&count=200&include_rts=1&since_id=#{tweet.id_twitter.to_i}")
      tweets = open_json.reverse
      results.reverse.each do |tweet|
        tweets << tweet
      end

      data = {}
      data[:tweets] = tweets.reverse

      File.open(@file_path, 'w') do |file|
        file.write(JSON.generate(data))
      end

      @stop = Time.now
      p "done! #{index} - #{candidate.screen_name.downcase} (#{@stop - @start} s)"
    end
  end
end
