require "rails"

module DbTunnel
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/db_tunnel.rake"
    end
  end
end