require_relative 'Tweet'
require 'quickchart'
require 'erb'

module DataVisualiser
  @@SYMBOL_CHARS_REGEX = /[^a-zA-Z0-9]/
  @@QUICK_CHART_URL = "https://quickchart.io/wordcloud?"

  def self.generate_word_cloud(words_hash)
    params = {
      'text'        => '', # empty for now, will update later
      'cleanWords'  => 'false',
      'useWordList' => 'true'
    }

    words_hash = words_hash.to_a[...20].to_h
    words_hash.each do |word, count|
      # add a comma only after at least one word has been added to text
      unless params['text'].empty?
        params['text'] << ','
      end

      params['text'] << "#{ERB::Util.url_encode(word)}:#{count}"
    end

    return generate_GET_request(@@QUICK_CHART_URL, params)
  end

  def self.generate_histogram(tweets)
    # calculate data
    data = Array.new(12, 0) # 12 for the 12 months , 0 for defult value
    labels = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEPT", "OCT", "NOV", "DEC"]

    for tweet in tweets do
      month = tweet.date.mon - 1 # - 1 bc date#mon returns (1 - 12)
      data[month] += 1
    end

    chart = QuickChart.new(
      {
        type: 'horizontalBar',
        data: {
          datasets: [
            {
              data: data,
              label: "Number of posts"
            }
          ],
          labels: labels,
        },
        options: {
          scales: {
            xAxes: [
              {
                ticks: {
                  beginAtZero: true # makes sure x starts at 0
                }
              }
            ]
          }
        }
      },
      width: 800,
      height: 800
    )

    return chart.get_url
  end

  def self.generate_pie_chart(chars_hash)
    # create new hash, only add in symbols
    symbol_hash = Hash.new

    for char, count in chars_hash do
      # if char matches regex pattern
      symbol_hash[char] = count if char =~ @@SYMBOL_CHARS_REGEX
    end

    chart = QuickChart.new(
      {
        type: "pie",
        data: {
          datasets: [
            {
              data: symbol_hash.values,
              label: 'Symbol Distribution',
            },
          ],
          labels: symbol_hash.map {|k, v| "#{k}: #{v}"} # formats legend to be: "<symbol>: <count>"
        },
        options: {
          plugins: {
            datalabels: {
              # this removes the count in the middle of the pies
              display: false
            }
          }
        }
      },
      width: 800,
      height: 800
    )

    return chart.get_url
  end

  private
  def self.generate_GET_request(endpoint, params)
    req = endpoint.dup

    for k, v in params do
      req << "#{k}=#{v.gsub(' ', '%20')}&" #v.gsub is there bc space is not allowed in url
    end

    return req
  end
end
