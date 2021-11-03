# Problem:
# Update the Device class to produce the expected output
#  Need to:
#   > Create a listen public instance method that will store the info that
#       has been passed in to be played letter
#   > Create a getter instance method called play that will display the last
#       item pushed to the @recorded instance variable

class Device
  def initialize
    @recordings = []
  end

  def record(recording)
    @recordings << recording
  end

  def listen
    @recordings << yield if block_given?
  end

  def play
    puts @recordings.last
  end

end

listener = Device.new
listener.listen
listener.listen { "Hello World!" }
listener.listen
listener.play # should utput "Hello World!"
# => "Hello World!"