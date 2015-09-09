class ExtractFollowersListInfo
  def initialize(attributes)
    @data_type = attributes[:data_type]
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
    attributes_selector(attributes)
  end

  def run
    create_interaction_instance
  end

  def update
    update_interaction_instance
  end

  def attributes_selector(attributes)
    case @data_type
      when 'followers tweets'
        @content_type = 'statuses_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 2000
      when 'followers listed'
        @content_type = 'listed_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 20
      when 'followers followings'
        @content_type = 'friends_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 1000
      when 'followers followers'
        @content_type = 'followers_count'
        @at_least = attributes[:at_least] ? attributes[:at_least] : 1000
    end
  end

  def extrac_data
    result = []
    Twitterdatum.where(data_type: 'follower').where(candidate_id: @candidate.id).each do |follower|
      result << follower.decode_data
    end
    return result
  end

  # get followers_count for each follower
  def extract_items_counts
    items_counts = []
    extrac_data.each do |follower|
      items_counts << follower[@content_type].to_i
    end
    return items_counts
  end

  # get average nb of followers
  def count_average
    return extract_items_counts.inject(:+) / extract_items_counts.length
  end

  # get percentage of followers_count >= @at_least
  def percent_count
    top_items = extract_items_counts.select { |c| c >= @at_least }
    return ((top_items.length.to_f / extrac_data.length) * 100).round
  end

  def create_interaction_instance
    Interaction.create!(data_type: @data_type, average: count_average, percentage: percent_count, candidate_id: @candidate.id)
  end

  def update_interaction_instance
    item = Interaction.where(candidate_id: @candidate.id).where(data_type: @data_type).first
    item[:average] = count_average
    item[:percentage] = percent_count
    item.save
  end
end
