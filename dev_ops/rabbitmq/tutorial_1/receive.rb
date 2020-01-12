require 'bunny'

# Connect to RabbitMQ server
connection = Bunny.new(host: 'localhost')
connection.start

channel = connection.create_channel

# Argument to queue must be string matching queue to be joined
queue = channel.queue('hello')

begin
  puts ' [*] Waiting for messages. To exit press CTRL+C'

  # "block: true" prevents the script from finishing execution - this is how it keeps the connection open 
  # the callback given to "subscribe" is invoked every time a message is received
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  connection.close

  exit(0)
end