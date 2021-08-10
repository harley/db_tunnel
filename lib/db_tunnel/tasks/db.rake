namespace :db_tunnel do
  desc "db_tunnel:on"
  task on: :environment do
    DbSync.tunnel_on
  end

  desc "db_tunnel:off"
  task off: :environment do
    DbSync.tunnel_off
  end

  desc "db_tunnel:check - check db connection with a query"
  task check: :environment do
    DbSync.tunnel_check
  end

  desc "db_tunnel:clone_db - just do it"
  task clone_db: :environment do
    DbSync.execute(from: :tunnel_staging, to: :local)
  end
end
