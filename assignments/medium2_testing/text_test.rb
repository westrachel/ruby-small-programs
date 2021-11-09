# Create tests for the Text class's following instance methods:
# > swap instance method
# > word_count instance method

require 'minitest/autorun'

require_relative 'text'

class CashRegisterTest < MiniTest::Test
  def setup
    @file = File.open("more_sample_text.txt")
    @sample_text = Text.new(@file.readlines.map(&:chomp).join(' '))
  end

  def test_swap
    a_letter_count = @sample_text.text.count('a')
    e_letter_count = @sample_text.text.count('e')
    count_expected_post_swap = a_letter_count + e_letter_count
    assert_equal(count_expected_post_swap, @sample_text.swap('a', 'e').count('e'))
  end

  def test_word_count
    assert_equal(72, @sample_text.word_count)
  end

  def teardown
    @file.close
  end
end
