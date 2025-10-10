# frozen_string_literal: true

require_relative "../command"
require "fileutils"

module Huebrew
  module CLI
    module Commands
      # Initialize huebrew user directories
      class Init < Command
        desc "Initialize huebrew user directories and configuration"

        def call(**)
          huebrew_dir = File.join(Dir.home, ".huebrew")

          puts "Initializing huebrew in #{huebrew_dir}..."

          # Create directories
          create_dir(File.join(huebrew_dir, "palettes"))
          create_dir(File.join(huebrew_dir, "templates"))
          create_dir(File.join(huebrew_dir, "cache"))
          create_dir(File.join(huebrew_dir, "themes"))

          # Create sample config if it doesn't exist
          config_path = File.join(huebrew_dir, "config.yml")
          if File.exist?(config_path)
            puts "  ✓ config.yml already exists"
          else
            create_sample_config(config_path)
          end

          puts
          puts "✨ Initialization complete!"
          puts
          puts "Next steps:"
          puts "  • Edit ~/.huebrew/config.yml to customize settings"
          puts "  • Run 'huebrew list palettes' to see available palettes"
          puts "  • Run 'huebrew --help' for more commands"
        rescue => e
          handle_error(e)
        end

        private

        def create_dir(path)
          if Dir.exist?(path)
            puts "  ✓ #{File.basename(path)}/ already exists"
          else
            FileUtils.mkdir_p(path)
            puts "  + Created #{File.basename(path)}/"
          end
        end

        def create_sample_config(path)
          config_content = <<~YAML
            # Huebrew Configuration
            # See https://github.com/andrewmcodes/huebrew for documentation

            # Default palette (format: source:family:scheme)
            default_palette: "radix:slate:light"

            # Default variant
            default_variant: "base"

            # Alpha handling mode (preserve, flatten, strip)
            alpha_mode: "preserve"

            # Fail on WCAG contrast violations
            fail_on_contrast_violation: true
          YAML

          File.write(path, config_content)
          puts "  + Created config.yml"
        end
      end
    end
  end
end
