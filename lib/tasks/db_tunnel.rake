namespace :db_tunnel do
  desc "db_tunnel:on[<tunnel-host>]"
  task :on, [:tunnel_host] => :environment do |task, args|
    DbTunnel::DbSync.new(tunnel_host: args[:tunnel_host]).tunnel_on
  end

  desc "db_tunnel:off"
  task :off, [:tunnel_host] => :environment do |task, args|
    DbTunnel::DbSync.new.tunnel_off
  end

  desc "db_tunnel:check[<ip>] - check db connection with a query"
  task check: :environment do
    DbTunnel::DbSync.tunnel_check
  end

  desc "db_tunnel:clone_db[<ip>] - copy db from staging to local"
  task clone_db: :environment do
    DbTunnel::DbSync.execute(from: :tunnel_staging, to: :local)
  end
end
