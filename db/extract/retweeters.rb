require 'json'

CANDIDATE_SCREEN_NAME = 'claudebartolone'
JSON_FILEPATH = "db/json/#{CANDIDATE_SCREEN_NAME}_retweeters.json"

def open_file(filepath)
  JSON.parse(File.open(filepath).read).first.last
end

def extract_screen_names
  retweeters = open_file(JSON_FILEPATH)
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
  sorted_count = count_occurences.sort_by { |key, value| value }.reverse.to_h
  top_result = {}
  x = 0
  until x == 19
   top_result[sorted_count.keys[x]] = sorted_count.values[x]
   x += 1
  end
  return top_result
end

