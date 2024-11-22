require 'csv'
require_relative 'Tweet'

class FileLoader
  @@STOP_WORD_CSV_FILE = "./stop_words.csv"
  @@CSV_HEADER_DATE = "date_created"
  @@CSV_HEADER_TEXT = "text"

  attr_reader :tweets
  attr_reader :tweet_texts

  def initialize(filepath)
    @tweets = Array.new
    @tweet_texts = Array.new

    load_file(filepath)
  end

  def load_file(filepath)
    # make sure arrays start as empty
    @tweet_texts.clear
    @tweets.clear

    CSV.foreach(filepath, :headers => true) do |row|
      text = row[@@CSV_HEADER_TEXT]
      date_string = row[@@CSV_HEADER_DATE]

      # for complete Tweets
      @tweets << Tweet.new(text, date_string)

      # for text only tweets
      @tweet_texts << text
    end
  end

  def self.load_stop_words
    stop_words = Array.new

    CSV.foreach(@@STOP_WORD_CSV_FILE) do |row|
      stop_words << row[0]
    end

    return stop_words
  end
end
