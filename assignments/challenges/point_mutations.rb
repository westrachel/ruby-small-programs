# Problem:
# Create a DNA class that calculates the hamming distance
#   of 2 DNA strands

# Requirements:
#  a) if the 2 strands being compared have varying lengths
#     calculate the hamming distance based on comparing
#     the lengths up to the shorter strand's length
#  b) hamming distance corresponds with the total number of
#     differences between 2 strands
#  c) based on test cases, want to store the DNA strand string
#     in an instance variable of the DNA class and then want
#     to compare 2 DNA string strands via the hamming_distance()
#     instance method that accepts 1 string argument

# Algorithm for hamming distances public instance method:
#  i. initialize a differences local variable that points to 0
#       > this variable will keep track of the number of differences
#            between the 2 string strands that are being compared
#  ii. define another helper instance method that accepts 2 string
#     arguments and returns the shorter string or if there is no
#     shorter string then default returns one of the strings
#  iii. initialize a strand1 local variable that points to the 
#       string strand that's returned from invoking the method 
#       described in ii. above
#  iv. initialize a strand2 local variable that points to other string
#      that's at play and should be reactive to whatever strand1's string
#      value is
#      > can use a ternary operator to check if the initialize strand1 is
#        equal to one of the strings and if it is then assign strand2 to
#        the other strand, if it's not then assign strand2 to the string
#        that strand1 was compared against w/ the == method
#  v. since strand1 points to the shorter string (if the strings at play
#     aren't the same length), chain the size method and the times method
#     onto strand1 to iterate over the 2 strings and compare if they have
#     the same string character at the same index
#      > the local block variable of the times method invocation w/ a block
#        will keep track of the index that each string strand should be 
#        sliced at
#      > increment the value that the differences local variable points to
#        by 1 if the 2 strings don't have the same value at the same indexed
#        position
#      > using the size of the shorter string as the calling object for the
#        times method invocation will ensure that only the appropriate length
#        of the 2 strings is compared (as detailed under requirement (a) above)

class DNA
  attr_reader :sequence
  def initialize(strand)
    @sequence = strand
  end

  def hamming_distance(other_sequence)
    differences = 0
    strand1 = shorter_strand_or_first_strand(sequence, other_sequence)
    strand2 = (strand1 == sequence ? other_sequence : sequence)
    strand1.size.times do |index|
      differences += 1 if strand1[index] != strand2[index]
    end
    differences
  end

  private

  def shorter_strand_or_first_strand(strand1, strand2)
    strand1.size < strand2.size ? strand1 : strand2
  end
end