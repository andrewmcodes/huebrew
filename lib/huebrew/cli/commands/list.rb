# frozen_string_literal: true

require_relative "../command"

module Huebrew
  module CLI
    module Commands
      # List palettes, variants, and exporters
      class List < Command
        desc "List available palettes, variants, and exporters"

        argument :type, type: :string, required: false, desc: "Type to list (palettes, variants, exporters)"

        def call(type: "palettes", **)
          case type
          when "palettes"
            list_palettes
          when "variants"
            list_variants
          when "exporters"
            list_exporters
          else
            warn "Unknown type: #{type}. Use: palettes, variants, or exporters"
            exit(1)
          end
        rescue => e
          handle_error(e)
        end

        private

        def list_palettes
          palettes = Huebrew.registry.palettes

          if palettes.empty?
            puts "No palettes found."
            return
          end

          puts "Available Palettes:"
          puts "-" * 60

          palettes.each do |palette|
            puts "  #{palette.id}"
            puts "    Name: #{palette.name}"
            puts "    Scheme: #{palette.scheme}"
            puts "    Families: #{palette.families.keys.join(", ")}"
            puts
          end
        end

        def list_variants
          require_relative "../../variant"

          variants = Huebrew::Variant.all

          puts "Available Variants:"
          puts "-" * 60

          variants.each do |variant|
            puts "  #{variant.id}"
            puts "    Name: #{variant.name}"
            puts "    Rules: #{variant.rules.size} transformation(s)"
            puts
          end
        end

        def list_exporters
          puts "Available Exporters:"
          puts "-" * 60
          puts "  fzf - FZF color configuration"
          puts "  vscode - VS Code theme"
          puts "  tmux - tmux configuration"
          puts "  neovim - Neovim Lua theme"
          puts "  raycast - Raycast theme"
        end
      end
    end
  end
end
