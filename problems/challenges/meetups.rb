# Problem:
# Create a class Meetup that instantiates objects with the instance variables
#   month and a year representing a specific month and year

# Requirements:
#  i. the class should have a day instance method that accepts 2 arguments and
#       returns the exact date of the meetup
#         > either argument can have mixed case 
#               <=> (ie FIRST, Thursday, tuesday are acceptable inputs)
#         > a weekday argument (= monday, tuesday, wednesday, etc.)
#         > the time that the weekday occurs in the month which indicates when the
#             meetup will happen
#             Ex: second
#              > if 2nd is input alongside wednesday, then the day instance method
#                 should return the exact day # alongside the month and year values
#                 that the object's instance variables point to
#         > the day instance method should return nil if an invalid date has been
#            selected

# Day instance method algorithm:
# i. find the desired day (monday, tuesday, wednesday, etc) in number terms that
#     corresponds with how the Data class's wday instance method maps string days
#     of the week to the numbers 0-6 (sunday == 0)
#       (a) create a hash constant that maps each string weekday (mon, tues, etc)
#           to a number 0 - 6
#       (b) lookup the day's weekday argument in the hash constant (key lookup)
#            and return the value associated w/ that weekday keey
# ii. find the desired number of instances of the weekday I'm trying to find
#       (b) create a hash constant that maps each first/second/etc second argument
#           of the day instance method to the corresponding desired number of
#           instances of the weekday that should occur when iterating over a month's
#           days to the find the exact desired date of the meetup
#             > both :first and :last should correspond with 1 desired instance of
#                the desired weekday
#             > if teenth is the argument then need to conduct a separate process
#                 b/c teenth can correspond w/ a variable number of desired instances
#
# iii. initialize a counter that keeps track of the number of instances the
#        desired day has been iterated over in a looping construct that will be
#        defined in the next few steps
# iv. initialize a day local variable that initially points to 1 or -1 depending on
#      if the meetup_day argument is 'last' or not
#       > if the meetup_day is last, then want to find the first instance of the
#         weekday when working backwards from the end of the month and can create
#         a Date instance object that corresponds with the last day of the month
#         by invoking Date.new(year, month, -1)
# v. initialize a current_day_of_the_month local variable that initially points to
#     an empty string
# vi. start a looping construct that continues to iterate until the desired day of
#       the month is found that corresponds w/ the meetup day
#      (a) w/in the loop create a current_day_of_the_month local variable that
#          points to a Date instance object that corresponds with the calling 
#          meetup object's month and year values and with the day local
#          variable's day numerical value
#            > will be starting w/ the 1st day of the month or last day of the month
#              as the day local variable initially points to 1 or -1
#            > there can be instances where the day instance method is called with
#                arguments that correspond with an invalid date and need to be able
#                to handle these instances
#            > the day instance method should return nil if an invalid date is referred
#               to; the Date.new() method invocation will return an ArgumentError if
#               an invalid combination of year, month, and day arguments are passed in
#               so in the loop when instantiating a Date instance object include rescue nil
#               to assign the current_day_of_the_month local variable to nil if an invalid
#               date is being referenced for a given month
#            > break out of the loop immediately if current_day_of_the_month local variable
#                is reassigned to nil
#      (b) check if the created date object's weekday matches the desired weekday in
#           numerial terms
#      (c) if (b)'s numerical comparison evaluates to true then add 1 to the counter
#            local variable tracking the number of instances of the desired weekday and
#            either add 1 or substract 1 from the day local variable depending of if 
#            the loop is iterating forward from the start of the month or iterating
#            backwards from the end of the month
#      (d) break the loop when have found the desired meetup day which corresponds when
#             the counter tracking the number of found instances of the desired weekday
#             is eqaul to the number of desired instances of the desired weekday
# vii. return the Date object that the current_day_of_the_month local variable points to
# viii. separate process if 'teenth' is the 2nd argument of the day instance method:
#        (a) initialize a day local variable to point to 13 if teenth is the 2nd argument
#              the "teenth" days of the month correspond with the days whose numerical values
#               are 13, 14, 15, 16, 17, 18 or 19
#        (b) initialize a current_day_of_month local variable that points to a Date object
#             whose day corresponds with the calling meetup object's year & month instance 
#             variable values and whose day is 13 initially
#        (c) start a loop that will iterate over the days of the month until it finds the
#              "teenth" day of the respective month whose weekday numerical value (0 - 6)
#               corresponds with the desired weekday's numerical value, where the desired
#               weekday is based on the day instance method's first argument ('monday', etc)

require 'date'

class Meetup

  NUM_INSTANCES = { :first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => 1 }
  DESIRED_DAY_NUM = { :sunday => 0, :monday => 1, :tuesday => 2, :wednesday => 3,
                      :thursday => 4, :friday => 5, :saturday => 6 }

  def initialize(year, month)
    @year = year
    @month = month
  end

  def day(weekday, meetup_day)
    desired_wday = DESIRED_DAY_NUM[weekday.downcase.to_sym]
    return find_teenth_wday(desired_wday) if meetup_day.downcase == 'teenth'
    number_of_desired_instances = NUM_INSTANCES[meetup_day.downcase.to_sym]
    day = (meetup_day.downcase == 'last' ? -1 : 1)
    find_exact_desired_date(number_of_desired_instances, day, desired_wday, meetup_day.downcase)
  end

  def find_exact_desired_date(number_of_desired_instances, day, desired_wday, meetup_day)
    count_instances_of_desired_day = 0
    current_day_of_month = ""
    until count_instances_of_desired_day == number_of_desired_instances
      current_day_of_month = Date.new(@year, @month, day) rescue nil
      break if current_day_of_month.nil?
      count_instances_of_desired_day += 1 if current_day_of_month.wday == desired_wday
      day += (meetup_day == 'last' ? -1 : 1)
    end
    current_day_of_month
  end

  def find_teenth_wday(desired_day)
    day = 13
    current_day_of_month = Date.new(@year, @month, day)
    until current_day_of_month.wday == desired_day
      day += 1
      current_day_of_month = Date.new(@year, @month, day)
    end
    current_day_of_month
  end
  
end
