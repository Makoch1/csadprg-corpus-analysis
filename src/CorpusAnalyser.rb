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

  # To identify the top 10 stop words, each word's IDF was calculated and ranked.
  # IDF = log (N / dt) where:
  #   N   is the total number of documents (tweets in this case)
  #   dt  is the number of documents (tweets) that contain the term t
  def get_stop_words
    idf_ranking = Hash.new

    # for each unique word
    unique_words.each do |word, _|
      dt = 0

      # check how many tweets the unique word appears in
      @tweets.each do |tweet|
        # process the tweet first, split into an array of words
        tweet_array = tweet.gsub(/[^A-z0-9^\s]/, "").downcase.split(" ")

        if tweet_array.include? word
          dt += 1
        end
      end

      # calculate the IDF
      if dt != 0
        idf_ranking[word] = Math.log(@tweets.size / dt, 2)
      else
        idf_ranking[word] = 0
      end
    end

    # sort and get the first 10
    return idf_ranking
      .sort_by {|_, v| v}[...10] # array slicing
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
