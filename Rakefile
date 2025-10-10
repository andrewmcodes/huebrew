# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

namespace :rbs do
  desc "Validate RBS type signatures"
  task :validate do
    require "rbs"
    require "rbs/cli"

    loader = RBS::EnvironmentLoader.new

    # Load the gem's RBS files
    sig_dir = File.join(__dir__, "sig")
    loader.add(path: Pathname(sig_dir))

    env = RBS::Environment.new
    loader.load(env: env)

    puts "✓ RBS signatures are valid"
  rescue RBS::NoTypeFoundError, RBS::InvalidTypeApplicationError => e
    puts "✗ RBS validation failed: #{e.message}"
    exit 1
  end

  desc "Run Steep type checker"
  task :steep do
    sh "bundle exec steep check --severity-level=warning" do |ok, _res|
      if ok
        puts "✓ Steep type checking passed"
      else
        puts "⚠ Steep found type warnings (not failing build)"
      end
    end
  end
end

task default: %i[spec standard rbs:validate]
