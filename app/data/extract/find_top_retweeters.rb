require 'json'

class FindTopRetweeters
  def initialize(attributes)
    @content_type = attributes[:content_type] ? attributes[:content_type] : 'screen_name'
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
    @data_type = "retweeters #{@content_type.gsub('_', ' ')}"
    @file_path = "app/data/json/#{attributes[:screen_name]}_retweeters.json"
  end

  def run
    store_in_database
  end

  def open_json
    JSON.parse(File.open(@file_path).read).first.last
  end

  def extract_content
    content = []
    open_json.each do |user|
      content << user[@content_type]
    end
    return content
  end

  def count_occurences
    content_count = Hash.new(0)
    extract_content.each do |word|
      content_count[word] += 1
    end
    return content_count
  end

  def sorted_and_selected
    return count_occurences.sort_by { |word, frequency| frequency }.reverse.first(@top_size).to_h
  end

  def store_in_database
    # Create topword instance
    topword = Topword.new(candidate_id: @candidate.id, data_type: @data_type)
    topword.save
    # Create words instances
    sorted_and_selected.each do |word, frequency|
      Word.create(topword_id: topword.id, content: word, count: frequency)
    end
  end
end
