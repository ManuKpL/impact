class ExtractCandidateRetweeted
  def initialize(attributes)
    @data_type = attributes[:data_type]
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    @content_type = attributes[:content_type] ? attributes[:content_type] : 'screen_name'
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
  end

  def run
    case @data_type
    when 'candidate retweets'
      create_interaction
    when 'candidate retweeted'
      create_topword
    end
  end

  def update
    case @data_type
    when 'candidate retweets'
      update_interaction
    when 'candidate retweeted'
      update_topword
    end
  end

  def extract_data
    result = []
    Twitterdatum.where(data_type: 'tweet').where(candidate_id: @candidate.id).each do |tweet|
      result << tweet.decode_data
    end
    return result
  end

  def select_candidate_retweeted
    result = []
    extract_data.each do |tweet|
      result << tweet['retweeted_status']['user'] if tweet['retweeted_status']
    end
    return result
  end

  def calculate_percentage
    return ((select_candidate_retweeted.length.to_f / extract_data.length) * 100).round
  end

  def calculate_top
    counted_names = Hash.new(0)
    select_candidate_retweeted.each do |user|
      counted_names[user[@content_type].downcase] += 1
    end
    return counted_names.sort_by { |name, frequency| frequency }.reverse.first(@top_size).to_h
  end

  def create_topword
    topword = Topword.new(candidate_id: @candidate.id, data_type: @data_type)
    topword.save
    calculate_top.each do |user, frequency|
      Word.create(topword_id: topword.id, content: user, count: frequency)
    end
  end

  def create_interaction
    Interaction.create({
      candidate_id: @candidate.id,
      data_type: @data_type,
      average: select_candidate_retweeted.length,
      percentage: calculate_percentage
    })
  end

  def update_topword
    topword = Topword.where(candidate_id: @candidate.id).where(data_type: @data_type).first
    Word.where(topword_id: topword.id).each_with_index do |word, index|
      word[:content] = calculate_top.keys[index]
      word[:count] = calculate_top.values[index]
      word.save
    end
  end

  def update_interaction
    item = Interaction.where(candidate_id: @candidate.id).where(data_type: @data_type).first
    item[:average] = select_candidate_retweeted.length,
    item[:percentage] = calculate_percentage
    item.save
  end
end
