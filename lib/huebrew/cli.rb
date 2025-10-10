# frozen_string_literal: true

require "dry/cli"
require_relative "cli/command"
require_relative "cli/commands/version"
require_relative "cli/commands/list"
require_relative "cli/commands/init"
require_relative "cli/commands/preview"
require_relative "cli/commands/build"
require_relative "cli/commands/export"

module Huebrew
  module CLI
    # Register all commands
    module Commands
      extend Dry::CLI::Registry

      register "version", Version, aliases: ["v", "-v", "--version"]
      register "list", List, aliases: ["ls"]
      register "init", Init
      register "preview", Preview
      register "build", Build
      register "export", Export
    end

    # Run the CLI
    def self.run(arguments = ARGV)
      Dry::CLI.new(Commands).call(arguments: arguments)
    end
  end
end
