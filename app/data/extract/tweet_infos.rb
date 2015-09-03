require 'json'
require_relative '../../../config/environment.rb'

CANDIDATE_SCREEN_NAME = 'claudebartolone'
json_filepath = "app/data/json/#{CANDIDATE_SCREEN_NAME}_tweets.json"

@tweets = JSON.parse(File.open(json_filepath).read).first.last


def average_number_of(key_name)
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
# p average_number_of("retweet_count")
# p average_number_of("favorite_count")

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
  sorted_hash.last(20)
end
# p sorted_by_occurence("user_mentions", "screen_name")
# p sorted_by_occurence("hashtags", "text")

def part_of_tweets(key_name, number)
  array_of_keys = []

  @tweets.each do |tweet|
    array_of_keys << tweet[key_name]
  end

  array_of_tweets_keyed_over_number = array_of_keys.select { |x| x > number }

  ((array_of_tweets_keyed_over_number.size.to_f / array_of_keys.size.to_f) * 100).round
end
# p part_of_tweets("retweet_count", 10)
# p part_of_tweets("favorite_count", 5)

def create_topword_instance(data_type)
  candidate = Candidate.find_by_screen_name(CANDIDATE_SCREEN_NAME)
  Topword.create(candidate_id: candidate.id, data_type: data_type)
end

def create_words_instances(mention_name, mentions_key, data_type)
  create_topword_instance(data_type)
  topword = Topword.find_by_data_type(data_type)
  sorted_by_occurence(mention_name, mentions_key).each do |word, frequency|
    Word.create(topword_id: topword.id, content: word, count: frequency)
  end
end

def create_interaction_instances(key_name, number, data_type)
  candidate = Candidate.find_by_screen_name(CANDIDATE_SCREEN_NAME)
  Interaction.create(candidate_id: candidate.id, data_type: data_type, average: average_number_of(key_name), percentage: part_of_tweets(key_name, number))
end

create_words_instances("hashtags", "text", "hashtags")
create_words_instances("user_mentions", "screen_name", "mentions")

create_interaction_instances("retweet_count", 10, "retweets")
create_interaction_instances("favorite_count", 5, "favorites")


