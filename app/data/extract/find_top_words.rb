class FindTopWords
  def initialize(attributes)
    @content_type = attributes[:content_type]
    @data_type = attributes[:data_type]
    @top_size = attributes[:top_size] ? attributes[:top_size] : 20
    @candidate = Candidate.find_by_screen_name(attributes[:screen_name])
  end

  def run
    store_in_database
  end

  def update
    update_database
  end

  def extract_data
    result = []
    Twitterdatum.where(data_type: @content_type).where(candidate_id: @candidate.id).each do |element|
      result << element.decode_data
    end
    return result
  end

  def get_array_of_content
    # user descriptions or tweets text
    results = []
    extract_data.each do |element|
      if element['description'].nil?
        results << element['text']
      else
        results << element['description']
      end
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
    frequency = Hash.new(0)
    remove_stopwords.each do |word|
      frequency[word.downcase] += 1
    end
    return frequency
  end

  def sorted_and_selected
    return count_occurences.sort_by { |word, frequency| frequency }.reverse.first(@top_size).to_h
  end

  def store_in_database
    # create toword instance to store words
    top_word = Topword.new(candidate_id: @candidate.id, data_type: @data_type)
    top_word.save
    # create words instances for each word
    sorted_and_selected.each do |word, frequency|
      Word.create(topword_id: top_word.id, content: word, count: frequency)
    end
  end

  def update_database
    topword = Topword.where(candidate_id: @candidate.id).where(data_type: @data_type).first
    Word.where(topword_id: topword.id).each_with_index do |word, index|
      word[:content] = sorted_and_selected.keys[index]
      word[:count] = sorted_and_selected.values[index]
      word.save
    end
  end
end
