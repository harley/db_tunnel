# frozen_string_literal: true

require_relative "db_tunnel/version"
require_relative "db_tunnel/db_sync"
require_relative "db_tunnel/railtie" if defined?(Rails)

module DbTunnel
  class Error < StandardError; end
  # Your code goes here...
end
