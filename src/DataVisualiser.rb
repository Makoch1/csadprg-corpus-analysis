require_relative 'Tweet'
require 'erb'

module DataVisualiser
  @@SYMBOL_CHARS_REGEX = /[^a-zA-Z0-9]/

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

  def self.generate_pie_chart(chars_hash)
    params = {
      'chd'   => 'a:', # incomplete, append actual data
      'chco'  => 'ff3030', # chart color, from dark red to light red
      'chs'   => '999x999', # chart size
      'cht'   => 'p3', # chart type (pie)
      'chtt'  => 'Symbol distribution', # chart title
      'chdl'  => '', # incomplete, legend for each pie part (separated by |)
    }

    # create new hash, only add in symbols
    symbol_hash = Hash.new

    for char, count in chars_hash do
      # if char matches regex pattern
      symbol_hash[ERB::Util.url_encode(char)] = count if char =~ @@SYMBOL_CHARS_REGEX
    end

    # format data (chd)
    params['chd'] << symbol_hash.values.join(',')

    # format legends (chdl) and labels (chl)
    params['chdl'] << symbol_hash.keys.join('|')

    return generate_GET_request(params)
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
