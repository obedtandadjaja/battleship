WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
  subscribe :setuplobby, 'lobby_socket#setup'
  subscribe :playgame, 'play#start_game'
  subscribe :fire, 'play#fire'
  subscribe :check_gameover, 'play#check_gameover'
  # subscribe :breakdownlobby, 'lobby_socket#breakdown'
  subscribe :client_disconnected, 'lobby_socket#breakdown'
  subscribe :connection_closed, 'lobby_socket#breakdown'
end
