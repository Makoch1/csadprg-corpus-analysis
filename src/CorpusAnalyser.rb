class CorpusAnalyser
  @@CHARS_TO_EXCLUDE = /[!,.?-]/
  attr_reader :words
  attr_reader :unique_words
  attr_reader :unique_chars

  def initialize(tweets)
    @tweets = tweets
    @words = Array.new
    @unique_words = Hash.new(0) # init default value to 0
    @unique_chars = Hash.new(0)

    for tweet in tweets do
      # split tweet into array of words, then
      #   (1) remove punctuation and convert to lowercase
      #   (2) add to words array
      #   (3) increment word_hash[word] by 1
      for word in tweet.split(" ") do
        # Not using gsub! because it returns nil when no transformation is done
        word = word.gsub(@@CHARS_TO_EXCLUDE, "").downcase

        @words << word
        @unique_words[word] += 1
      end

      # split tweet into array of chars, then
      #   (1) check if it is a space character
      #   (2) if not, increment char_hash[char] by 1
      for char in tweet.chars do
        unless char == ' '
          @unique_chars[char] += 1
        end
      end
    end
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
end
