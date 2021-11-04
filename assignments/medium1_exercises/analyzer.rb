# Problem:
# Update the TextAnalyzer class to define a process instance
#  method that can receive text via a block that's then parsed
#  to return the number of paragraphs, number of sentences, and the
#  number of words. Leverage the process instance method to output
#  the number of words, lines, and paragraphs for the sample text.

class TextAnalyzer
  def process
    yield
  end
end

analyzer = TextAnalyzer.new

file = File.open("sample_text.txt")
text = file.readlines.map(&:chomp)
file.close

# Expected output:
# => 3 paragraphs
# => 15 lines
# => 126 words

analyzer.process { paragraphs = 1 
 text.each do |phrase|
   paragraphs += 1 if phrase.empty?
  end
  puts paragraphs.to_s + " paragraphs" }
# => 3paragraphs
  
analyzer.process { puts text.size.to_s + " lines" }
# => 15 lines

analyzer.process { words = 0
 text.each do |phrase|
   words += phrase.split(' ').size
  end
  puts words.to_s + " words" }
# => 126 paragraphs
