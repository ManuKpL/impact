require 'json'

json_filepath = '../json/tweets.json'

@tweets = JSON.parse(File.open(json_filepath).read).first.last


def average_number_of(key_name) # mettre un nom plus générique
  array_of_keys = []

  @tweets.each do |tweet|
    array_of_keys << tweet[key_name]
  end

  sum = 0
  array_of_keys.each do |x|
    sum += x.to_i
  end

  keys_average = sum / array_of_keys.size
end


def sorted_by_occurence(mention_name, mentions_key)
  array_of_entities = []
  array_of_mentions = []
  array_of_mentions_key = []


  @tweets.each do |tweet|
    array_of_entities << tweet["entities"] if tweet["retweeted_status"].nil? #mettre unless à la place de if pour récupérer les retweets parmis ses tweets
  end

  array_of_entities.each do |entity|
    array_of_mentions << entity[mention_name]
  end

  array_of_mentions.each do |mentions|
    unless mentions.empty?
      mentions.each do |mention|
        array_of_mentions_key << mention[mentions_key]
      end
    end
  end

  hash_words = {}
  array_of_mentions_key.each do |word|
    w = word.downcase
    if hash_words.key? (w)
      hash_words[w] += 1
    else
      hash_words[w] = 1
    end
  end

  sorted_hash = hash_words.sort_by do |word, frequency|
    frequency
  end
  sorted_hash
end

p sorted_by_occurence("user_mentions", "screen_name")


