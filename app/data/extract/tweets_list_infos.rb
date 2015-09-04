require 'json'

class ExtractTweetsListInfos
  def initialize(attributes)
    # name of the data_type attribute in the db table
    @data_type = attributes[:data_type]
    # check if extracting an Interaction instance or a Topword instance
    @check = attributes[:minimum_count]
    # number of hashtags or mentions in the top
    # default value : 20
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    # find the candidate whose tweets will be analyzed and the tweets file
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
    @file_path = "app/data/json/#{attributes[:screen_name]}_tweets.json"
    # runs the method attributing instance values for each case of analysis
    attributes_selector(attributes)
  end

  def run
    @check ? create_interaction_instances : create_words_instances
  end

  # returns an attributes hash to call methods in run
  def attributes_selector(attributes)
    case @data_type
      when 'retweets'
        @content_type = 'candidate tweets'
        @key_name = 'retweet_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 10
      when 'RT retweets'
        @content_type = 'candidate retweets'
        @key_name = 'retweet_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 10
      when 'favorites'
        @content_type = 'candidate tweets'
        @key_name = 'favorite_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 5
      when 'RT favorites'
        @content_type = 'candidate retweets'
        @key_name = 'favorite_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 5
      when 'hashtags'
        @content_type = 'candidate tweets'
        @mention_name = @data_type
        @mention_key = 'text'
      when 'RT hashtags'
        @content_type = 'candidate retweets'
        @mention_name = @data_type
        @mention_key = 'text'
      when 'mentions'
        @content_type = 'candidate tweets'
        @mention_name = 'user_mentions'
        @mention_key = 'screen_name'
      when 'RT mentions'
        @content_type = 'candidate retweets'
        @mention_name = 'user_mentions'
        @mention_key = 'screen_name'
      else
        @content_type = nil
        @key_name = nil
        @mention_name = nil
        @mention_key = nil
    end
  end

  def open_json
    JSON.parse(File.open(@file_path).read).first.last
  end

  def average_number
    sum = 0
    open_json.each do |tweet|
      sum += tweet[@key_name] if tweet[@key_name]
    end
    return sum / open_json.length
  end

  def sorted_by_occurence
    # puts each hashtag or mention in an array
    result = []
    open_json.each do |tweet|
      datas = tweet['entities'][@mention_name]
      # discriminate between tweets or retweets (performed by the candidate)
      if @content_type == 'candidate tweets'
        datas.each { |element| result << element } if tweet['retweeted_status'].nil? && datas.length > 0
      else
        datas.each { |element| result << element } if tweet['retweeted_status'] && datas.length > 0
      end
    end

    # counts the number of occurrence of ech mention or hashtag and returns a hash
    counted_words = Hash.new(0)
    result.each do |word|
      counted_words[word[@mention_key].downcase] += 1
    end

    # sorts the hash from biggest use to smallest and selects the first mentions according to @count (default : 20)
    return counted_words.sort_by { |word, frequency| frequency }.reverse.first(@top_size).to_h
  end

  def part_of_tweets
    # select all tweets that have at least the @minimum_count of retweets or favorites
    result = open_json.select do |tweet|
      tweet[@key_name] >= @minimum_count
    end

    # calculate the percentage
    return ((result.length.to_f / open_json.length) * 100).round
  end

  def create_words_instances
    topword = Topword.new(candidate_id: @candidate.id, data_type: @data_type)
    topword.save
    sorted_by_occurence.each do |word, frequency|
      Word.create({
          topword_id: topword.id,
          content: word,
          count: frequency
        })
    end
  end

  def create_interaction_instances
    Interaction.create({
        candidate_id: @candidate.id,
        data_type: @data_type,
        average: average_number,
        percentage: part_of_tweets
      })
  end
end
