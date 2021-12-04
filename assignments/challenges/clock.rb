# Problem:
# Create a clock class that keeps track of time based on arithmetic operations

# Requirements:
#  > do not use any built-in date/time functions
#  > 2 clock objects that have the same time should be equal
#     > based on test cases, need to define custom #== method that
#        compares the 2 times of a clock object
#  > times range from 0 hours to 24 hours
#  > need to define a to_s method that will return the string version of
#     of the time that's formatted as: "##:##"
#     > can call the to_s method w/in the #== instance method defined to
#        compare that the two times are equivalent for 2 different clock objects

# Class Method "at" Algorithm/Notes:
# i. method should accept 2 numerical arguments, w/ the 2nd one being optional
#     > the first argument represents the hour, the second argument represents
#          the current minutes
#              <=> so, Clock.at(23, 30) represents the time 23:30
# ii. initialize a new Clock object when the at class method is called that
#     returns a clock object establish an hour and minutes instance variable for
#     the clock object upon initializing a new clock object
# iii. should be able to subtract or add numerical values from the return value
#       of the at method
#     > since I've defined the at method to return a clock object, that means I
#        need to define subtraction and addition instance methods for the Clock
#        class
# iv. Custom subtraction/addition instance method algorithm:
#     a) convert the clock object's hour and mins instance variable values to a
#         total number of minutes value
#           @hour * 60 + mins == total # of mins associated w/ the clock
#             object's current time
#     b) subtract or add the minutes numerical argument passed into the method
#         on invocation from the total number of minutes found in part (a)
#     c) if the return value from (b) is a negative amount then call a 
#         negative_time_conversion instance method, otherwise call a 
#         positive_time_conversion instance method
#     d) positive_time_conversion instance method algorithm:
#         > divide the new time's total number of mins found in part (b) by
#           60 and reassign the hour instance variable to this value if this
#           value is less than 24
#             > if this new hour value is greater than or equal to 24 then
#                 subtract from it (24 times (itself / 24))
#             > the previous step will return a whole hour number value < 24
#                 ex: 3661 is the new time in minutes 
#                    3661 / 60 == 61 (new hours amount)
#                    (61 - (24 * (61 / 24)) == 13) == new desired hour amount
#
#         > subtract from the new time's total number of mins found in part
#           (b) the product of multiplying the number that the hour instance
#           variable now points to post reassignment by 60 <=> the return value
#           corresponds w/ the new time's number of minutes
#         > reassign the @mins instance variable to the number of minutes
#           found in the prior step
#     e) negative_time_conversion instance method algorithm:
#         ex case 1: Clock.at(0, 30) represents the time "00:30"; if subtract 60
#         from this time then the current time in string format would be "23:30"
#             > the new_time_in_mins value that corresponds w/ this ex == -30
#             > if add (-30) to 1440 get 1410
#                <=> 1440 is the return of 24 hours times 60 minutes (working
#                   backwards from the 24th hour)
#             > can pass 1410 as the argument into the positive_time_conversion
#                method previously defined in order to reassign the clock object's
#                hour and mins instance variables to the new desired amount
#     f) return self (which refers to the clock object in instance methods) as
#          the return value of the subtraction/addition instance methods
#          > this is needed b/c the return value of the +/- instance methods
#              are assigned to clock local variables in the test cases and the
#              to_s instance method is subsequently called on the objects that
#              these clock instance variables point to

class Clock
  attr_accessor :hour, :mins
  def initialize(hour, mins=0)
    @hour = hour
    @mins = mins
  end

  def self.at(hour, mins=0)
    self.new(hour, mins)
  end

  def -(minutes)
    new_time_in_mins = (hour * 60 + mins) - minutes
    case new_time_in_mins
    when (0..Float::INFINITY) then positive_time_conversion(new_time_in_mins)
    else negative_time_conversion(new_time_in_mins)
    end
    self
  end

  def +(minutes)
    new_time_in_mins = (hour * 60 + mins) + minutes
    case new_time_in_mins
    when (0..Float::INFINITY) then positive_time_conversion(new_time_in_mins)
    else negative_time_conversion(new_time_in_mins)
    end
    self
  end

  def positive_time_conversion(time_in_mins)
    new_raw_hours = time_in_mins / 60
    self.hour = case new_raw_hours
                when (0...24) then new_raw_hours
                else new_raw_hours - (24 * (new_raw_hours / 24))
                end
    self.mins = time_in_mins - (new_raw_hours * 60)
  end

  def negative_time_conversion(time_in_mins_negative_value)
    positive_time_conversion((1440 + time_in_mins_negative_value))
  end

  def to_s
    time = ""
    time << (hour.to_s.size == 2 ? hour.to_s : "0#{hour}")
    time << ":"
    time << (mins.to_s.size == 2 ? mins.to_s : "0#{mins}")
    time
  end

  def ==(other_clock)
    to_s == other_clock.to_s
  end
end
