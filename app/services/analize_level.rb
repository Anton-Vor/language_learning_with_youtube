class AnalizeLevel
  STEPS = {
    0 => "beginner",
    200 => "intermediate",
    320 => "advanced"
  }

  def initialize(subtitle_words)
    @subtitle_words = subtitle_words
  end

  def call
    find_treshold_word
    level
    @rank #replace with level later
  end

  private

  def frequent_words
    @frequent_words ||= Word.all.order(:rank).pluck(%i[en rank]).to_h
  end

  def find_treshold_word
    order_by_rank
    index = @subtitle_words_ordered.count - (@subtitle_words_ordered.count * 0.4).to_i - 1
    @treshold_word = @subtitle_words_ordered[index]
  end

  def order_by_rank
    @subtitle_words_ordered = @subtitle_words.sort do |w1, w2|
      word_range(w1) <=> word_range(w2)
    end
  end

  def level
    # ap @treshold_word
    @rank = word_range(@treshold_word)
    puts "DEBUG: #{@treshold_word}: rank:#{@rank}"
    STEPS.keys.reverse.each do |key|
      return STEPS[key] if key < @rank
    end
  end

  def word_range(word)
    frequent_words[word] || 5000
  end
end

# puts '====================='
# words = ['a', 'b', 'c', 'd', 'e']
# res = AnalizeLevel.new(words).call
# puts 'd'
# puts "res: #{res}"
# # -> 1
# puts '====================='
# words = ['a', 'b', 'e', 'a', 'b']
# res = AnalizeLevel.new(words).call
# puts 'a'
# puts "res: #{res}"
# # -> 1

# puts '====================='
# words = ['e', 'e', 'e', 'e', 'g']
# res = AnalizeLevel.new(words).call
# puts 'e'
# puts "res: #{res}"
# # -> 2
# puts '====================='
# words = ['a', 'a', 'a', 'e', 'e', 'a']
# res = AnalizeLevel.new(words).call
# puts 'e'
# puts "res: #{res}"
# # -> 2
