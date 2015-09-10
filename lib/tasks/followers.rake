namespace :followers do

  desc 'open JSON and create followers instances'
  task :seed => :environment do
    def open_json
      p "opening json..."
      JSON.parse(File.open(@file_path).read).first.last
    end

    Candidate.all.each_with_index do |candidate, index|
      start = Time.now
      @file_path = "app/data/json/#{candidate.screen_name.downcase}_followers.json"
      open_json.each do |follower|
        twitterdatum = Twitterdatum.new(candidate_id: candidate.id, data_type: "follower", id_twitter: follower['id_str'])
        twitterdatum.data = twitterdatum.encode_data(follower)
        twitterdatum.save
      end
      stop = Time.now
      p "done! #{index} - #{candidate.name} (#{stop - start} s)"
    end
  end

  desc 'add new followers instances without JSON'
  task :update => :environment do
    Candidate.all.each do |candidate|
      ids = $twitter.follower_ids(candidate.screen_name).attrs[:ids].slice(0,300).reverse

      start = 0
      stop = start + 99
      ids_s = []
      while stop < ids.length
        ids_s << ids[start..stop].join(',')
        start = stop + 1
        stop = start + 99
      end
      stop = ids.length - 1

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

