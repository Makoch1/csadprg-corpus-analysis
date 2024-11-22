require_relative("./FileLoader")

class CorpusAnalyser
  @@CHARS_TO_EXCLUDE = /[^A-z^\s]/
  attr_reader :words
  attr_reader :unique_words
  attr_reader :unique_chars

  def initialize(tweets)
    @tweets = tweets
    @words = Array.new
    @unique_words = Hash.new(0) # init default value to 0
    @unique_chars = Hash.new(0)

    _calc_word_count
    _calc_char_count
  end

  public
  def get_word_count
    return @words.size
  end

  def get_vocabulary_size
    return @unique_words.size
  end

  def get_word_frequency
    sorted = @unique_words
      .sort_by {|_, v| v}
      .reverse
      .to_h

    return sorted
  end

  def get_character_frequency
    sorted = @unique_chars
      .sort_by {|_, v| v}
      .reverse
      .to_h

    return sorted
  end

  def get_stop_words
    # load stop word bag
    stop_words_bag = FileLoader.load_stop_words

    stop_words = Hash.new
    for word in stop_words_bag do
      if unique_words.has_key?(word)
        stop_words[word] = unique_words[word] # copy the frequency from unique words
      end
    end

    return stop_words
      .sort_by {|_, v| v}
      .reverse[...10]
      .to_h
  end

  private
  def _calc_word_count
    for tweet in @tweets do
      for word in tweet.split(" ") do
        @words << word
        @unique_words[word] += 1
      end
    end
  end

  def _calc_char_count
    for tweet in @tweets do
      # remove the unicode emoji modifiers
      # this is done bc of the red heart emoji 
      tweet = tweet.gsub(/\p{M}/, "")

      for char in tweet.chars do
        @unique_chars[char] += 1 unless char == ' '
      end
    end
  end
end
