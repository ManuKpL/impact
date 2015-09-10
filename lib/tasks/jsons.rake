namespace :jsons do

  desc 'create JSON with followers instances'
  task :create => :environment do

    candidates = %w(dupontaignan vpecresse claudebartolone emmacosse wdesaintjust YannWehrling Chantal_Jouanno n_arthaud DelarueJC aurelien_veron plaurent_pcf SylvainDeSmet)
    candidates.each_with_index do |screen_name, index|
      @start = Time.now
      @file_path = "app/data/json/#{screen_name.downcase}_followers.json"
      cursor = -1
      ids = []
      until cursor == 0
        extract = $twitter.get("https://api.twitter.com/1.1/followers/ids.json?cursor=#{cursor}&screen_name=#{screen_name}&count=5000")
        extract[:ids].each do |id|
          ids << id
        end
        cursor = extract[:next_cursor]
        puts "waiting"
        sleep 60
        puts "done"
      end

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

      users = []
      ids_s.each_with_index do |string, index|
        $twitter.get('https://api.twitter.com/1.1/users/lookup.json?user_id=' << string).each do |user|
          users << user
        end
        print "Loading"
        3.times do
          sleep 1
          print "."
        end
        sleep 1
        puts "."
        sleep 1
        puts ">Done! (#{index + 1} - #{users.length} followers added)"
      end

      data = {}
      data[:users] = users

      File.open(@file_path, 'w') do |file|
        file.write(JSON.generate(data))
      end

      @stop = Time.now
      p "done! #{index} - #{screen_name} (#{((@stop - @start) / 3600)}s - #{users.length} followers)"
    end
  end

  desc 'update JSON with followers instances'
  task :update => :environment do
    def open_json
      JSON.parse(File.open(@file_path).read).first.last
    end

    candidates = %w(dupontaignan vpecresse claudebartolone emmacosse wdesaintjust YannWehrling Chantal_Jouanno n_arthaud DelarueJC aurelien_veron plaurent_pcf SylvainDeSmet)
    candidates.each_with_index do |screen_name, index|
      @start = Time.now
      @file_path = "app/data/json/#{screen_name.downcase}_followers.json"
      ids = $twitter.follower_ids(screen_name).attrs[:ids].slice(0,590).reverse

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

      users = open_json.reverse
      ids_s.each do |string|
        $twitter.get('https://api.twitter.com/1.1/users/lookup.json?user_id=' << string).each do |follower|
          users << follower
        end
      end

      data = {}
      data[:users] = users.reverse

      File.open(@file_path, 'w') do |file|
        file.write(JSON.generate(data))
      end

      @stop = Time.now
      p "done! #{index} - #{screen_name.downcase} (#{@stop - @start} s)"
    end
  end
end

