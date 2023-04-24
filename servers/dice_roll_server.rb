# Update the simple echo server, so that it can roll >= 1
#  dice that can have a dynamic # of sides

def parse_request(request_line)
  # request line is a string like: GET”/?rolls=2&sides=6 HTTP/1.1”
  # split the request_line into desired components
  http_method, path_and_params, http_version = request_line.split("")
  path, parameters = path_and_params("?")

  # reassign parameters to hash whose key/value pairs track the
  #   # of rolls and # of sides specified based on client's URL
  parameters = parameters.each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, parameters]
end

require “socket”   
server = TCPServer.new(“localhost”, 3003)
loop do
  client = server.accept
  
  request_line = client.gets
  puts request_line

  http_method, path, parameters = parse_request(request_line)

  # assign to local variables the integer values of the # of rolls & sides
  rolls = parameters["rolls"].to_i
  sides = parameters["sides"].to_i

  # print in the browser the request line & the values rolled
  client.puts request_line
  msg_start = "You rolled a: "
  rolls.times do |_|
    num = (rand(sides) + 1).to_s
    client.puts msg_start + num
  end
   
  client.close
end
