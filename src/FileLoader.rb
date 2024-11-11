require 'csv'
require_relative 'Tweet'

class FileLoader
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
end
