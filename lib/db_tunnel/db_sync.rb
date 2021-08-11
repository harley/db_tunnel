module DbTunnel
  class DbSync
    attr_accessor :tunnel_host

    def initialize(tunnel_host: nil)
      self.tunnel_host = tunnel_host || ENV["TUNNEL_HOST"]
    end

    def tunnel_on
      crdes, db_host_db_name = stag_db_url.split("@")
      db_host, db_name = db_host_db_name.split("/")

      print "Preparing SSH tunnel localhost:#{tunnel_port} through #{tunnel_host}... "
      cmd = %( ssh -f -N -L #{tunnel_port}:#{db_host} #{tunnel_username}@#{tunnel_host} )
      result = system(cmd)
      puts result ? "Succeeded." : "Failed."
    end

    def tunnel_check
      sql = "SELECT COUNT(*) FROM users;"
      puts "Checking DB access: #{sql}"

      cmd = "psql #{tunnel_staging_db_url} -c '#{sql}'"
      # puts cmd
      system cmd
    end

    def tunnel_off
      cmd = "lsof -ti:#{tunnel_port} | xargs kill -9"
      puts "Killing SSH tunnel: #{cmd}"
      system cmd
    end

    def execute(from:, to:)
      cmd = clone_cmd(from: from, to: to)
      puts "[DbSync#execute] #{cmd}"

      # execute cmd and stream output
      Open3.popen3(cmd) do |stdout, stderr, status, thread|
        while (line = stderr.gets)
          puts(line)
        end
      end
    end

    private

    def tunnel_username
      ENV["TUNNEL_USERNAME"] || "deployer"
    end

    def tunnel_port
      ENV["TUNNEL_PORT"] || "6543"
    end

    def clone_cmd(from:, to:)
      from_url = get_url(from)
      to_url = get_url(to)

      raise "Cannot clone to production!!!" if to.to_s == "production"

      %(pg_dump #{from_url} | PGOPTIONS='--client-min-messages=warning' psql #{to_url})
    end

    # lazily evaluated
    def get_url(env)
      case env
      when :production then prod_db_url
      when :staging then stag_db_url
      when :tunnel_staging then tunnel_staging_db_url
      else local_db_url
      end
    end

    def prod_db_url
      Rails.application.encrypted("config/credentials/production.yml.enc", key_path: "config/credentials/production.key").config[:DATABASE_URL]
    end

    def stag_db_url
      Rails.application.encrypted("config/credentials/staging.yml.enc", key_path: "config/credentials/staging.key").config[:DATABASE_URL]
    end

    # local DATABASE_URL is not in config/credentials.yml.enc because that file is used for both test and development
    def local_db_url
      ENV["DATABASE_URL"] || "postgres://localhost:5432/xshop_development"
    end

    def tunnel_staging_db_url
      creds, db_host_db_name = stag_db_url.split("@")
      _, db_name = db_host_db_name.split("/")

      "#{creds}@localhost:#{tunnel_port}/#{db_name}"
    end
  end
end