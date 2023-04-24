# Problem:
# Write a function that when given a URL as a string,
#  parses out just the domain name and returns it as a string.

# Input: string containing a url
# Output: returns a string that represents the domain of the inputted url

# Examples:
#* url = "http://github.com/carbonfive/raygun" -> "github"
#* url = "http://www.zombie-bites.com"         -> "zombie-bites"
#* url = "https://www.cnet.com"                -> "cnet"

# Requirements:
# > domain name either starts after the second '/' or after a '.' if the url
#     contains 3 consecutive 'w' characters

# Algorithm:
# i. Create a flag local variable that's a boolean that is true if the inputted url contains 3 consecutive 'w' characters and false otherwise
#      a. initialize a counter variable that points to zero
#      b. iterate through all the characters in the url string, and on each iteration:
#           > check if the character is a 'w' and if it's not, then don't add anything to the number the counter variable points to
#           > if the character is a 'w' then add 1 to the counter variable
#           > if the counter variable is already > 0, and the letter being iterated over is not a 'w' then reset the counter variable to 0
#           > break the looping mechanism if the counter variable makes it to 3
# ii. Create an array that will store the indices of all the '/' characters if the boolean flag is false
# iii. Create another array that will store the indices of all the '.' characters 
# iv. Find the starting index of the domain, which is the index of the first domain character:
#      > if the boolean flag is true, then the starting index is going to be one index to the right of the index of the first '.' character in the string
#      > if the boolean flag is false, then the starting index is going to be one index to the right of the index of the first '/' character in the string
# v. Find the ending index of the domain, which is the index of the last character of the domain name:
#     > if the boolean flag is true, then the ending index is going to be one index to the left of the index of the second '.' character in the string
#     > if the boolean flag is false, then the ending index is going to be one index to the left of the index of first '.' character in the string
# vi. subset the inputted string selecting all the characters that occur between and including the starting index and ending index

def three_consecutive_ws?(str)
  count_consecutive_ws = 0
  str.chars.each_with_index do |char, idx|
    if str[idx - 1] == 'w' && str[idx + 1]
      count_consecutive_ws += 1
    end
  end
  count_consecutive_ws >= 1 ? true : false
end

def find_all_indices(character, string)
  indices = []
  string.chars.each_with_index do |char, index|
    indices << index if char == character
  end
  indices
end

def domain_name(url)
  three_w_chars = three_consecutive_ws?(url)
  backslash_indices = find_all_indices('/', url)
  period_indices = find_all_indices('.', url)
  array_for_starting_idx = (three_w_chars ? period_indices : backslash_indices)
  addend_for_starting_idx = (three_w_chars ? 1 : 2)
  ending_pd_element = (three_w_chars ? 1 : 0)
  starting_idx = array_for_starting_idx[0] + addend_for_starting_idx
  ending_idx = period_indices[ending_pd_element] - 1
  url[starting_idx..ending_idx]
end

# check work:
domain_name("http://www.zombie-bites.com")
# => "zombie-bites" 

domain_name("http://github.com/carbonfive/raygun")
# => "github"
