# frozen_string_literal: true

require "dry/cli"

module Huebrew
  module CLI
    # Base command class
    class Command < Dry::CLI::Command
      def initialize
        super
        Huebrew.configure
      end

      protected

      def exit_code_for(error)
        case error
        when Huebrew::SchemaError, Huebrew::ConfigError
          2
        when Huebrew::NotFoundError
          3
        when Huebrew::ContrastViolationError
          4
        else
          1
        end
      end

      def handle_error(error)
        warn "Error: #{error.message}"
        exit(exit_code_for(error))
      end
    end
  end
end
