require_relative 'Tweet'

module DataVisualiser
  def generate_word_cloud(words_hash)
  end

  def self.generate_histogram(tweets)
    params = {
      'chbr'  => '10', # border radius
      'chco'  => '5faac7', # bar colors
      'chd'   => 'a:', # this is not complete, append actual data later
      'chs'   => '800x400', # chart size
      'cht'   => 'bvs', # chart type (bar vertical single)
      'chtt'  => 'Tweets per month', # chart title
      'chxl'  => '0:|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEPT|OCT|NOV|DEC', # x axis labels
      'chxt'  => 'x,y'
    }

    # calculate data
    data = Array.new(12, 0)

    for tweet in tweets do
      month = tweet.date.mon - 1 # Date#mon returns (1 - 12)
      data[month] += 1
    end

    # format data (chd)
    params['chd'] << data.join(',')

    return generate_GET_request(params)
  end

  def generate_pie_chart(chars_hash)
  end

  private
  def self.generate_GET_request(params)
    req = "https://image-charts.com/chart?"

    for k, v in params do
      req << "#{k}=#{v.gsub(' ', '%20')}&" #v.gsub is there bc space is not allowed in url
    end

    return req
  end
end
