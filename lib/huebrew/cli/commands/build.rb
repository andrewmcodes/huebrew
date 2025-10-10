# frozen_string_literal: true

require_relative "../command"
require_relative "../../theme"
require "yaml"
require "json"

module Huebrew
  module CLI
    module Commands
      # Build and preview a theme
      class Build < Command
        desc "Build a theme from palette and variant"

        argument :palette_id, type: :string, required: false, desc: "Palette ID (e.g., radix:slate:light)"

        option :variant, type: :string, desc: "Variant to apply (base, dim, high_contrast)"
        option :format, type: :string, default: "yaml", desc: "Output format (yaml, json)"
        option :family, type: :string, desc: "Only show tokens for specific family"

        def call(palette_id: nil, variant: nil, format: "yaml", family: nil, **)
          palette_id ||= Huebrew.config.default_palette
          variant_id = variant || Huebrew.config.default_variant

          palette = Huebrew.registry.palette(palette_id)
          unless palette
            warn "Palette not found: #{palette_id}"
            warn "Run 'huebrew list palettes' to see available palettes"
            exit(3)
          end

          variant_obj = Huebrew::Variant.get(variant_id)
          unless variant_obj
            warn "Variant not found: #{variant_id}"
            warn "Run 'huebrew list variants' to see available variants"
            exit(3)
          end

          theme = Huebrew::Theme.new(palette: palette, variant: variant_obj)

          puts "Theme: #{palette.name} + #{variant_obj.name}"
          puts "=" * 60
          puts

          # Get tokens
          tokens = if family
            theme.tokens_for_family(family)
          else
            theme.tokens
          end

          # Convert colors to hex strings for output
          token_map = tokens.transform_values { |color| color.to_hex(include_alpha: color.a < 1.0) }

          # Output in requested format
          case format
          when "json"
            puts JSON.pretty_generate(token_map)
          when "yaml"
            puts token_map.to_yaml
          else
            warn "Unknown format: #{format}. Use 'yaml' or 'json'"
            exit(1)
          end
        rescue => e
          handle_error(e)
        end
      end
    end
  end
end
