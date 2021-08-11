# frozen_string_literal: true

require_relative "lib/db_tunnel/version"

Gem::Specification.new do |spec|
  spec.name          = "db_tunnel"
  spec.version       = DbTunnel::VERSION
  spec.authors       = ["Harley Trung"]
  spec.email         = ["build@coderpush.com"]

  spec.summary       = "Useful db tasks through SSH tunnel"
  spec.description   = "Never put database in public because it's not as secure as SSH. Connect to DB via SSH for one-time uses."
  spec.homepage      = "https://github.com/harley/db_tunnel"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/harley/db_tunnel"
  spec.metadata["changelog_uri"] = "https://github.com/harley/db_tunnel/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "> 6.0"
  spec.add_dependency "rake"
  spec.add_dependency "bundler", ">= 2.0"
  spec.add_dependency "railties", ">= 6"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
