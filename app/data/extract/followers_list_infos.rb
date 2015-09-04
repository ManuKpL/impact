require 'json'

class ExtractFollowersListInfo
  def initialize(attributes)
    @data_type = attributes[:data_type]
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
    @file_path = "app/data/json/#{attributes[:screen_name]}_followers.json"
    attributes_selector(attributes)
  end

  def run
    create_interaction_instance
  end

  def attributes_selector(attributes)
    case @data_type
      when 'followers tweets'
        @content_type = 'statuses_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 2000
      when 'followers listed'
        @content_type = 'listed_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 20
      when 'followers followings'
        @content_type = 'friends_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 1000
      when 'followers followers'
        @content_type = 'followers_count'
        @minimum_count = attributes[:minimum_count] ? attributes[:minimum_count] : 1000
    end
  end

  def open_json
    JSON.parse(File.open(@file_path).read).first.last
  end

  # get followers_count for each follower
  def extract_items_counts
    items_counts = []
    open_json.each do |follower|
      items_counts << follower[@content_type].to_i
    end
    return items_counts
  end

  # get average nb of followers
  def count_average
    return extract_items_counts.inject(:+) / extract_items_counts.length
  end

  # get percentage of followers_count >= @minimum_count
  def percent_count
    top_items = extract_items_counts.select { |c| c >= @minimum_count }
    return ((top_items.length.to_f / open_json.length) * 100).round
  end

  def create_interaction_instance
    Interaction.create!(data_type: @data_type, average: count_average, percentage: percent_count, candidate_id: @candidate.id)
  end
end
