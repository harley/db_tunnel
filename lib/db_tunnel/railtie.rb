require "db_tunnel"
require "rails"

puts "Railtie"
module DbTunnel
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/db.rake"
    end
  end
end