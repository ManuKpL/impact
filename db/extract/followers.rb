require 'json'

# filepaths
stopwords_filepath = "db/extract/stopwords.txt"
json_filepath = "db/json/followers.json"
# get array of followers
def get_followers_descriptions(filepath)
  followers = JSON.parse(File.open(filepath).read).first.last
  # get array of descriptions
  descriptions = []
  followers.each do |follower|
    descriptions << follower['description']
  end
  return descriptions
end

def format_array(array)
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

def remove_stopwords(words, stopwords_filepath)
  # remove stopwords
  stopwords = File.open(stopwords_filepath).read.split(' ')
  words = words - stopwords
  return words
end

def get_top_words(words)
  # count frequency
  frequency = Hash.new(0)
  words.each { |word| frequency[word.downcase] += 1 }
  sorted = frequency.sort_by { |word, count| count }.reverse.to_h
  top_words = sorted.select {|k,v| v > 200}
  return top_words
end

descriptions = get_followers_descriptions(json_filepath)
formatted = format_array(descriptions)
words = remove_stopwords(formatted, stopwords_filepath)
top_words = get_top_words(words)
p top_words


# create topwords instance type string 'followers bios'

# top_words = Topword.new
# create words instances for each word
