# Problem:
# Requirements:
#  > each new fish starts with a timer of 8 that specifies the number
#     of days before it can create a new fish
#  > when a fish's timer gets to 0, it creates a new fish and its
#     production timer gets to reset, but reset to 6 and not 8
#  > model the production of fish that will display how many fish
#      there are after a random number of days speicfied as an input
#  > the starting cohort of fishes' ages will also be given

class Fish
  attr_accessor :production_timer, :newborn

  @@fishes = []

  def initialize(production_timer)
    @production_timer = production_timer
  end

  def self.produce_initial_fish(production_timer_values_array)
    production_timer_values_array.each do |production_timer|
      @@fishes << Fish.new(production_timer)
    end
  end

  def self.produce(number_of_days)
    number_of_days.times do |_|
      start_of_day
    end
    display_number_of_fishes(number_of_days)
  end
  
  def self.start_of_day
    number_new_fish_to_create_at_days_end = 0
      @@fishes.each do |fish|
        if fish.production_timer > 0
          fish.production_timer -= 1
        elsif fish.production_timer == 0
          fish.production_timer = 6
          number_new_fish_to_create_at_days_end += 1
        end
      end
    number_new_fish_to_create_at_days_end.times do |_|
      @@fishes << Fish.new(9)
    end
  end

  def self.show_timers
    @@fishes.each_with_object([]) do |fish, array|
      array << fish.production_timer
    end
  end

  def self.display_number_of_fishes(num_days)
    puts "There are #{@@fishes.size} fishes after #{num_days} days."
  end
end

# check work:
Fish.produce_initial_fish([3,4,3,1,2])

Fish.produce(5) # there should be 10 fishes
