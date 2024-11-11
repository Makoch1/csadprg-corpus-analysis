require 'date'

class Tweet
  attr_reader :text
  attr_reader :date

  def initialize(text, date_string)
    @text = text
    @date = Date.parse(date_string)
  end
end

