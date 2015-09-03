require 'json'
require_relative '../../../config/environment'

# filepaths
STOPWORDS_FILEPATH = "app/data/extract/stopwords.txt"
JSON_FILEPATH = "app/data/json/claudebartolone_followers.json"
# get array of followers
def open_json(filepath)
  elements_array = JSON.parse(File.open(filepath).read).first.last
  # get array of descriptions
  results = []
  elements_array.each do |element|
    if element['description']
      results << element['description']
    else
      results << element['text']
    end
  end
  return results
end

def format_array
  array = open_json(JSON_FILEPATH)
  # join the array
  joined = array.join(' ').downcase
  # replace acronyms
  joined = joined.gsub("p.s", "ps")
  # replace accents
  joined = joined.gsub(/[éèêëàâäûüù]/, 'é' => 'e','è' => 'e', 'ê' => 'e', 'ë' => 'e', 'à' => 'a', 'â' => 'a', 'ä' => 'a','û' => 'u','ü' => 'u', 'ù' => 'u')
  # replace other special characters by a simple space
  joined = joined.gsub(/['"-,.]/,  "'" => ' ', '"' => ' ', '-' => ' ', ',' => ' ', '.' => ' ')
  # get the words which length > 3
  formatted = joined.split(' ').delete_if {|word| word.length < 2 }
  return formatted
end

def remove_stopwords
  words = format_array
  stopwords = File.open(STOPWORDS_FILEPATH).read.split(' ')
  words = words - stopwords
  return words
end

def get_top_words
  words = remove_stopwords
  frequency = Hash.new(0)
  words.each { |word| frequency[word.downcase] += 1 }
  sorted = frequency.sort_by { |word, count| count }.reverse.to_h
  top_words = sorted.select {|k,v| v > 200}
  return top_words
end
# create topwords instance type string 'followers bios'
def create_model_instances
  top_words = get_top_words
  barto = Candidate.find_by_screen_name("claudebartolone")
  top_barto = Topword.new(candidate_id: barto.id, data_type: "followers bios")
  top_barto.save
  # create words instances for each word
  top_words.each do |word, count|
    Word.create(topword_id: top_barto.id, content: word, count: top_words[word])
  end
end

p create_model_instances


