require 'json'

class RetweetersTop20Mentions
  def initialize(screen_name)
    @file_path = "app/data/json/#{screen_name}_retweeters.json"
    @screen_name = screen_name
  end

  def run
    create_words_instances
  end

  def open_file
    JSON.parse(File.open(@file_path).read).first.last
  end

  def extract_screen_names
    retweeters = open_file
    screen_name = []
    retweeters.each do |user|
      screen_name << user['screen_name']
    end
    return screen_name
  end

  def count_occurences
    screen_name = extract_screen_names
    screen_name_list = screen_name.uniq
    screen_name_count = {}
    screen_name_list.each do |name|
      screen_name_count[name.to_sym] = screen_name.count(name)
    end
    return screen_name_count
  end

  def sorted_and_trunkated
    sorted_count = count_occurences.sort_by { |word, frequency| frequency }.reverse.to_h
    top_result = {}
    x = 0
    until x == 20
     top_result[sorted_count.keys[x]] = sorted_count.values[x]
     x += 1
    end
    return top_result
  end

  def create_topword_instance
    candidate = Candidate.find_by_screen_name(@screen_name)
    Topword.create(candidate_id: candidate.id, data_type: 'retweeters screen name')
  end

  def create_words_instances
    create_topword_instance
    topword = Topword.find_by_data_type('retweeters screen name')
    sorted_and_trunkated.each do |word, frequency|
      Word.create(topword_id: topword.id, content: word, count: frequency)
    end
  end
end
