require "db_tunnel"
require "rails"

module DbTunnel
  class Railtie < Rails::Railtie
    railtie_name :db_tunnel

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end