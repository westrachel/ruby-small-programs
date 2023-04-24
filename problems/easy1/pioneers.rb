# Problem:
# Create a program that translates each of the given names that
#   were encrypted with Rot13

# Requirements:
#   > given names have spaces separating first/last/middle names
#   > names can have hyphens that should be left as is
#       > no other punctuation is given but can create the method
#         so as to leave characters that aren't in the alphabet as
#         they are
#   > I'll assume that I should maintain the case of the characters given
#      > that means capitalizing the character after it's been translated if
#         the original character pre-translation was capitalized

ABCS = ("a".."z").to_a

ROT13_PAIRS = {}
index = 0
until index == 13
  ROT13_PAIRS[ABCS[index]] = ABCS[(index+13)]
  index += 1
end

# check that hash to hold ROT13 pairs was created as intended:
p ROT13_PAIRS
# {"a"=>"n", "b"=>"o", "c"=>"p", "d"=>"q", "e"=>"r",
#  "f"=>"s", "g"=>"t", "h"=>"u", "i"=>"v", "j"=>"w",
#  "k"=>"x", "l"=>"y", "m"=>"z"}

def translate(name)
  name.chars.map do |letter|
    upcase_flag = true if letter.downcase.upcase == letter
    char = letter.downcase
    new_char = if ROT13_PAIRS.keys.include?(char)
                 ROT13_PAIRS[char]
               elsif ROT13_PAIRS.values.include?(char)
                 ROT13_PAIRS.key(char)
               else
                 char # char is some other punctuation, like a hyphen
               end
    upcase_flag ? new_char.upcase : new_char
  end.join('')
end

def rotate_thirteen_back(full_name)
  names = full_name.split(' ')
  translated_name = names.map do |name|
    translate(name)
  end
  translated_name.join(' ')
end

# Check Work:
p rotate_thirteen_back("Nqn Ybirynpr")
# => "Ada Lovelace"
p rotate_thirteen_back("Nqryr Tbyqfgvar")
# => "Adele Goldstine"
p rotate_thirteen_back("Nyna Ghevat")
# => "Alan Turing"
p rotate_thirteen_back("Puneyrf Onoontr")
# => "Charles Babbage"
p rotate_thirteen_back("Noqhyynu Zhunzznq ova Zhfn ny-Xujnevmzv")
# => "Abdullah Muhammad bin Musa al-Khwarizmi"
p rotate_thirteen_back("Wbua Ngnanfbss")
# => "John Atanasoff"
p rotate_thirteen_back("Ybvf Unvog")
# => "Lois Haibt"
p rotate_thirteen_back("Pynhqr Funaaba")
# => "Claude Shannon"
p rotate_thirteen_back("Fgrir Wbof")
# => "Steve Jobs"
p rotate_thirteen_back("Ovyy Tngrf")
# => "Bill Gates"
p rotate_thirteen_back("Gvz Orearef-Yrr")
# => "Tim Berners-Lee"
p rotate_thirteen_back("Fgrir Jbmavnx")
# => "Steve Wozniak"
p rotate_thirteen_back("Xbaenq Mhfr")
# => "Konrad Zuse"
p rotate_thirteen_back("Fve Nagbal Ubner")
# => "Sir Antony Hoare"
p rotate_thirteen_back("Zneiva Zvafxl")
# => "Marvin Minsky"
p rotate_thirteen_back("Lhxvuveb Zngfhzbgb")
# => "Yukihiro Matsumoto"
p rotate_thirteen_back("Unllvz Fybavzfxv")
# => "Hayyim Slonimski"
p rotate_thirteen_back("Tregehqr Oynapu")
# => "Gertrude Blanch"
