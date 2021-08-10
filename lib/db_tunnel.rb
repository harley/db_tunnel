# frozen_string_literal: true

require_relative "db_tunnel/version"
require "db_tunnel/railtie" if defined?(Rails)

module DbTunnel
  class Error < StandardError; end
  # Your code goes here...
end
