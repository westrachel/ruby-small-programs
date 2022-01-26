# require socket library, which contains classes that assist
#  in creating & interacting with servers & conducting other
#  networking actions
require "socket"

# Instantiate a new TCP server object
#   first argument: creates server on localhost
#   second argument: establishes the port #
#      > picked random port #, so as to not interfere 
#        with processes tied to other more standard port #s
server = TCPServer.new("localhost", 3003)

# loop establishes 
loop do
  # server.accept returns a client object that will be used
  #  to interact with the remote application server
  client = server.accept

  # assign request_line local variable to the client's request,
  #  which is the return value of client.gets
  request_line = client.gets
  puts request_line

  # print the request in the browser
  client.puts request_line
  # close the connection
  client.close
end