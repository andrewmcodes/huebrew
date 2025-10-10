# frozen_string_literal: true

require_relative "../../exporter"

module Huebrew
  module Exporters
    module Eza
      # Eza color exporter (v1)
      # Generates EZA_COLORS environment variable configuration
      class V1 < Exporter
        def initialize
          super
          @name = "Eza"
          @output_kind = :string
        end

        # Eza doesn't support alpha
        def capabilities
          {
            supports_alpha: false,
            wants_rgb: false,
            flatten_alpha: true
          }
        end

        # Render Eza color configuration
        # @param palette [Palette] Palette to export
        # @param family [String] Family name to export (defaults to first family)
        # @param dest [String, nil] Unused for string output
        # @return [String] Eza color configuration
        def render(palette:, family: nil, dest: nil)
          family_name = family || palette.families.keys.first
          family_data = palette.families[family_name]

          raise ExportError, "Family '#{family_name}' not found" unless family_data

          # Get background color for alpha blending
          bg_color = family_data["steps"][1]

          # Map roles to Eza color codes
          # Eza uses ANSI color codes for file/directory attributes
          colors = {
            "uu" => ansi_color(family_data["steps"][12], bg_color), # user name (text)
            "uR" => ansi_color(family_data["steps"][10], bg_color), # user name (root) (solidHover)
            "un" => ansi_color(family_data["steps"][11], bg_color), # user id (textMuted)
            "gu" => ansi_color(family_data["steps"][11], bg_color), # group name (textMuted)
            "da" => ansi_color(family_data["steps"][9], bg_color),  # date (solid)
            "ur" => ansi_color(family_data["steps"][9], bg_color),  # user read (solid)
            "uw" => ansi_color(family_data["steps"][10], bg_color), # user write (solidHover)
            "ux" => ansi_color(family_data["steps"][9], bg_color),  # user execute (solid)
            "ue" => ansi_color(family_data["steps"][9], bg_color),  # user execute file (solid)
            "gr" => ansi_color(family_data["steps"][8], bg_color),  # group read (borderHover)
            "gw" => ansi_color(family_data["steps"][10], bg_color), # group write (solidHover)
            "gx" => ansi_color(family_data["steps"][8], bg_color),  # group execute (borderHover)
            "tr" => ansi_color(family_data["steps"][7], bg_color),  # other read (border)
            "tw" => ansi_color(family_data["steps"][10], bg_color), # other write (solidHover)
            "tx" => ansi_color(family_data["steps"][7], bg_color),  # other execute (border)
            "xx" => ansi_color(family_data["steps"][10], bg_color)  # special file (solidHover)
          }

          # Format color pairs
          color_pairs = colors.map do |name, code|
            "#{name}=#{code}"
          end

          # Generate export statement with line continuation
          output = []
          output << "# ---------------------"
          output << "# eza #{palette.name}"
          output << "# ---------------------"
          output << "export EZA_COLORS=\"\\"
          color_pairs.each do |pair|
            output << "#{pair}:\\"
          end
          # Remove trailing backslash from last line
          output[-1] = output[-1].chomp(":\\")
          output[-1] += "\""

          output.join("\n")
        end

        private

        # Convert hex color to ANSI color code
        # @param color [Color] Color to convert
        # @param bg [Color] Background color for alpha blending
        # @return [String] ANSI color code
        def ansi_color(color, bg)
          # Flatten alpha if needed
          formatted = format_color(color, bg: bg)

          # Convert hex to RGB
          hex = formatted.delete("#")
          r = hex[0..1].to_i(16)
          g = hex[2..3].to_i(16)
          b = hex[4..5].to_i(16)

          # Convert to ANSI 256 color code
          # Using the 216-color cube (16-231) for better color accuracy
          if r == g && g == b
            # Grayscale (232-255)
            if r < 8
              16
            elsif r > 248
              231
            else
              232 + ((r - 8) / 10)
            end
          else
            # RGB cube
            16 + (36 * (r / 51)) + (6 * (g / 51)) + (b / 51)
          end
        end
      end
    end
  end
end
