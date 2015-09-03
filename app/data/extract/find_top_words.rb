require 'json'

class FindTopWords
  def initialize(attributes)
    @screen_name = attributes[:screen_name]
    @content_type = attributes[:content_type]
    @data_type = attributes[:data_type]
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    @file_path = "app/data/json/#{@screen_name}_#{@content_type}.json"
  end

  def run
    store_in_database
  end

  def open_json
    JSON.parse(File.open(@file_path).read).first.last
  end

  def get_array_of_content
    # user descriptions or tweets text
    elements_array = open_json
    results = []
    elements_array.each do |element|
      results << element['description'] ? element['description'] : element['text'] # either tweets or users
    end
    return results
  end

  def format_array
    joined = get_array_of_content.join(' ').downcase
    # replace acronyms
    joined = joined.gsub("p.s", "ps")
    # replace accents
    joined = joined.gsub(/[éèêëàâäûüù]/, 'é' => 'e','è' => 'e', 'ê' => 'e', 'ë' => 'e', 'à' => 'a', 'â' => 'a', 'ä' => 'a','û' => 'u','ü' => 'u', 'ù' => 'u')
    # replace other special characters by a simple space
    joined = joined.gsub(/['"-,.]/,  "'" => ' ', '"' => ' ', '-' => ' ', ',' => ' ', '.' => ' ')
    # get the words which length >= 2
    joined.split(' ').delete_if { |word| word.length < 2 }
  end

  def remove_stopwords
    stopwords = File.open('app/data/extract/stopwords.txt').read.split(' ')
    format_array - stopwords
  end

  def count_occurences
    words = remove_stopwords
    frequency = Hash.new(0)
    words.each do |word|
      frequency[word.downcase] += 1
    end
    return frequency
  end

  def sorted_and_selected
    sorted_count = count_occurences.sort_by { |word, frequency| frequency }.reverse.to_h
    top_words = {}
    x = 0
    until x == @top_size
     top_words[sorted_count.keys[x]] = sorted_count.values[x]
     x += 1
    end
    return top_words
  end

  def store_in_database
    # Find candidate instance
    candidate = Candidate.find_by_screen_name(@screen_name)
    # create toword instance to store words
    top_word = Topword.new(candidate_id: candidate.id, data_type: @data_type)
    top_word.save
    # create words instances for each word
    sorted_and_selected.each do |word, frequency|
      Word.create(topword_id: top_word.id, content: word, count: frequency)
    end
  end
end
