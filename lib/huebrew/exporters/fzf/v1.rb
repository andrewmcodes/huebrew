# frozen_string_literal: true

require_relative "../../exporter"

module Huebrew
  module Exporters
    module FZF
      # FZF color exporter (v1)
      # Generates FZF_DEFAULT_OPTS color configuration
      class V1 < Exporter
        def initialize
          super
          @name = "FZF"
          @output_kind = :string
        end

        # FZF doesn't support alpha
        def capabilities
          {
            supports_alpha: false,
            wants_rgb: false,
            flatten_alpha: true
          }
        end

        # Render FZF color configuration
        # @param palette [Palette] Palette to export
        # @param family [String] Family name to export (defaults to first family)
        # @param dest [String, nil] Unused for string output
        # @return [String] FZF color configuration
        def render(palette:, family: nil, dest: nil)
          family_name = family || palette.families.keys.first
          family_data = palette.families[family_name]

          raise ExportError, "Family '#{family_name}' not found" unless family_data

          # Get background color for alpha blending
          bg_color = family_data["steps"][1]

          # Map roles to FZF color names
          colors = {
            "fg" => family_data["steps"][12], # text
            "bg" => family_data["steps"][1], # bg
            "hl" => family_data["steps"][9], # solid (accent)
            "fg+" => family_data["steps"][12], # text (current line)
            "bg+" => family_data["steps"][3], # surface (current line)
            "hl+" => family_data["steps"][10], # solidHover (current line accent)
            "info" => family_data["steps"][11], # textMuted
            "prompt" => family_data["steps"][9], # solid
            "pointer" => family_data["steps"][9], # solid
            "marker" => family_data["steps"][10], # solidHover
            "spinner" => family_data["steps"][11], # textMuted
            "header" => family_data["steps"][11], # textMuted
            "border" => family_data["steps"][7], # border
            "label" => family_data["steps"][11], # textMuted
            "query" => family_data["steps"][12] # text
          }

          # Format colors
          color_pairs = colors.map do |name, color|
            formatted = format_color(color, bg: bg_color)
            "#{name}:#{formatted}"
          end

          # Generate export statement
          "export FZF_DEFAULT_OPTS=\"--color=#{color_pairs.join(",")}\""
        end
      end
    end
  end
end
