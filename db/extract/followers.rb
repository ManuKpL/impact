require 'json'

# filepaths
stopwords_filepath = "stopwords.txt"
json_filepath = "../followers.json"

# get array of followers
followers = JSON.parse(File.open(json_filepath).read).first.last

# get array of descriptions
descriptions = []
followers.each do |follower|
  descriptions << follower['description']
end

# clean the descriptions

# join the array
joined_descriptions = descriptions.join(' ').downcase
# replace accents
joined_descriptions = joined_descriptions.gsub(/[éèêëàâäûüù]/, 'é' => 'e','è' => 'e', 'ê' => 'e', 'ë' => 'e', 'à' => 'a', 'â' => 'a', 'ä' => 'a','û' => 'u','ü' => 'u', 'ù' => 'u')
# replace other special characters by a simple space
joined_descriptions = joined_descriptions.gsub(/['"-,.]/,  "'" => ' ', '"' => ' ', '-' => ' ', ',' => ' ', '.' => ' ')


# get the words which length > 3
words = joined_descriptions.split(' ').delete_if {|word| word.length <= 3 }

# remove stopwords
stopwords = File.open(stopwords_filepath).read.split(' ')
words = words - stopwords


# count frequency
frequency = Hash.new(0)
words.each { |word| frequency[word.downcase] += 1 }
sorted = frequency.sort_by { |word, count| count }.reverse.to_h

# select words that appear more than 200 times
p sorted.select {|k,v| v > 200}  #=> {"a" => 100}










