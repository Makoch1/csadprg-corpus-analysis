require_relative 'DataVisualiser'
require_relative 'CorpusAnalyser'
require_relative 'FileLoader'
require_relative 'Tweet'
require 'erb'

def main(filepath)
  fl = FileLoader.new(filepath)
  ca = CorpusAnalyser.new(fl.tweet_texts)

  # -- Build html using templates

  counts_html = ERB
    .new(File.read('../templates/counts.erb'))
    .result_with_hash(
      word_count: ca.get_word_count,
      unique_count: ca.get_vocabulary_size
  )

  word_frequency = ca.get_word_frequency
  word_freq_html = ERB
    .new(File.read('../templates/frequency_table.erb'))
    .result_with_hash(
      title: 'Word frequency',
      header: 'Word',
      frequency_hash: word_frequency
  )

  char_freq_html = ERB
    .new(File.read('../templates/frequency_table.erb'))
    .result_with_hash(
      title: 'Character frequency',
      header: 'Char',
      frequency_hash: ca.get_character_frequency
  )

  top20_word_html = ERB
    .new(File.read('../templates/frequency_table.erb'))
    .result_with_hash(
      title: 'Top 20 words',
      header: 'Word',
      frequency_hash: word_frequency.to_a[...20].to_h
    )

  stop_word_html = ERB
    .new(File.read('../templates/stopword_table.erb'))
    .result_with_hash(
      title: 'Stop words (10)',
      header: 'Word',
      frequency_hash: ca.get_stop_words
    )

  graphs_html = ERB
    .new(File.read('../templates/graphs.erb'))
    .result_with_hash(
      word_cloud_src: DataVisualiser.generate_word_cloud(word_frequency),
      histogram_src: DataVisualiser.generate_histogram(fl.tweets),
      pie_chart_src: DataVisualiser.generate_pie_chart(ca.get_character_frequency)
  )

  results_html = ERB
    .new(File.read('../templates/results.erb'))
    .result_with_hash(
      counts: counts_html,
      word_freq_table: word_freq_html,
      char_freq_table: char_freq_html,
      stop_word_table: stop_word_html,
      top20_word_table: top20_word_html,
      graphs: graphs_html
  )

  File.open('result.html', 'w+') do |f|
    f.write results_html
  end

  puts "Results are in: #{File.expand_path('./result.html')}"
end

# check filename arg
if ARGV.length != 1
  Kernel.abort "csv filepath arg missing!\n Usage: ruby Main.rb <filepath>"
end

# check if filepath is actually a path
filepath = ARGV[0]
unless File.file?(filepath)
  Kernel.abort "filepath supplied does not exist!"
end

main(filepath)
