require 'json'

class ExtractCandidateRetweeted
  def initialize(attributes)
    @data_type = attributes[:data_type]
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    @at_least = attributes[:at_least] ? attributes[:at_least] : 10
    @content_type = attributes[:content_type] ? attributes[:content_type] : 'screen_name'
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
    @file_path = "app/data/json/#{attributes[:screen_name]}_tweets.json"
  end

  def run
    case @data_type
    when 'candidate retweets'
      create_interaction
    when 'candidate retweeted'
      create_topword
    end
  end

  def open_json
    JSON.parse(File.open(@file_path).read).first.last
  end

  def select_candidate_retweeted
    result = []
    open_json.each do |tweet|
      result << tweet['retweeted_status']['user'] if tweet['retweeted_status']
    end
    return result
  end

  def calculate_percentage
    return ((select_candidate_retweeted.length.to_f / open_json.length) * 100).round
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
end
