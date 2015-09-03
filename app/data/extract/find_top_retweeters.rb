require 'json'

class FindTopRetweeters
  def initialize(attributes)
    @screen_name = attributes[:screen_name]
    @content_type = attributes[:content_type] ? attributes[:content_type] : 'screen_name'
    @data_type = attributes[:data_type] ? attributes[:data_type] : 'retweeters screen name'
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    @file_path = "app/data/json/#{@screen_name}_retweeters.json"
  end

  def run
    store_in_database
  end

  def open_json
    JSON.parse(File.open(@file_path).read).first.last
  end

  def extract_content
    retweeters = open_json
    content = []
    retweeters.each do |user|
      content << user[@content_type]
    end
    return content
  end

  def count_occurences
    content = extract_content
    content_count = Hash.new(0)
    content.each do |word|
      content_count[word] += 1
    end
    return content_count
  end

  def sorted_and_selected
    sorted_count = count_occurences.sort_by { |word, frequency| frequency }.reverse.to_h
    top_result = {}
    x = 0
    until x == @top_size
     top_result[sorted_count.keys[x]] = sorted_count.values[x]
     x += 1
    end
    return top_result
  end

  def store_in_database
    # Find candidate instance
    candidate = Candidate.find_by_screen_name(@screen_name)
    # Create topword instance
    topword = Topword.new(candidate_id: candidate.id, data_type: @data_type)
    topword.save
    # Create words instances
    sorted_and_selected.each do |word, frequency|
      Word.create(topword_id: topword.id, content: word, count: frequency)
    end
  end
end
