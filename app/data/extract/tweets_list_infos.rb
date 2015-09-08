class ExtractTweetsListInfos
  def initialize(attributes)
    # name of the data_type attribute in the db table
    @data_type = attributes[:data_type]
    # check if extracting an Interaction instance or a Topword instance
    @check = attributes[:at_least]
    # number of hashtags or mentions in the top
    # default value : 20
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    # find the candidate whose tweets will be analyzed and the tweets file
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
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
        @at_least = attributes[:at_least] ? attributes[:at_least] : 10
      when 'RT retweets'
        @content_type = 'candidate retweets'
        @key_name = 'retweet_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 10
      when 'favorites'
        @content_type = 'candidate tweets'
        @key_name = 'favorite_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 5
      when 'RT favorites'
        @content_type = 'candidate retweets'
        @key_name = 'favorite_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 5
      when 'hashtags'
        @content_type = 'candidate tweets'
        @mention_name = @data_type
        @mention_key = 'text'
      when 'RT hashtags'
        @content_type = 'candidate retweets'
        @mention_name = 'hashtags'
        @mention_key = 'text'
      when 'mentions'
        @content_type = 'candidate tweets'
        @mention_name = 'user_mentions'
        @mention_key = 'screen_name'
      when 'RT mentions'
        @content_type = 'candidate retweets'
        @mention_name = 'user_mentions'
        @mention_key = 'screen_name'
    end
  end

  def extract_data
    result = []
    Twitterdatum.where(data_type: 'tweet').where(candidate_id: @candidate.id).each do |tweet|
      result << tweet.decode_data
    end
  end

  def average_number
    sum = 0
    extract_data.each do |tweet|
      sum += tweet[@key_name] if tweet[@key_name]
    end
    return sum / extract_data.length
  end

  def sorted_by_occurence
    # puts each hashtag or mention in an array
    result = []
    extract_data.each do |tweet|
      datas = tweet['entities'][@mention_name]
      # discriminate between tweets or retweets (performed by the candidate)
      if datas
        if @content_type == 'candidate tweets'
          datas.each { |element| result << element } if tweet['retweeted_status'].nil? && datas.length > 0
        elsif @content_type == 'candidate retweets'
          datas.each { |element| result << element } if tweet['retweeted_status'] && datas.length > 0
        end
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
    # select all tweets that have at least the @at_least of retweets or favorites
    result = extract_data.select do |tweet|
      tweet[@key_name] >= @at_least
    end

    # calculate the percentage
    return ((result.length.to_f / extract_data.length) * 100).round
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
