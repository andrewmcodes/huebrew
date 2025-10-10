# frozen_string_literal: true

require_relative "../command"

module Huebrew
  module CLI
    module Commands
      # Preview color palette in terminal
      class Preview < Command
        desc "Preview a color palette in the terminal"

        argument :palette_id, type: :string, required: false, desc: "Palette ID (e.g., radix:slate:light)"
        option :family, type: :string, desc: "Family to preview (defaults to first family)"

        def call(palette_id: nil, family: nil, **)
          palette_id ||= Huebrew.config.default_palette
          palette = Huebrew.registry.palette(palette_id)

          unless palette
            warn "Palette not found: #{palette_id}"
            warn "Run 'huebrew list palettes' to see available palettes"
            exit(3)
          end

          family_name = family || palette.families.keys.first

          unless palette.families.key?(family_name)
            warn "Family '#{family_name}' not found in palette"
            warn "Available families: #{palette.families.keys.join(", ")}"
            exit(3)
          end

          display_palette(palette, family_name)
        rescue => e
          handle_error(e)
        end

        private

        def display_palette(palette, family_name)
          puts "Palette: #{palette.name}"
          puts "Family: #{family_name}"
          puts "Scheme: #{palette.scheme}"
          puts
          puts "Color Steps:"
          puts "-" * 80

          family_data = palette.families[family_name]
          steps = family_data["steps"]

          steps.each do |step, color|
            role = Huebrew::Palette::ROLE_STEP_MAP.key(step) || "step#{step}"
            display_color(step, role, color)
          end

          # Display alpha steps if present
          alpha_steps = family_data["alpha_steps"]
          if alpha_steps && !alpha_steps.empty?
            puts
            puts "Alpha Steps:"
            puts "-" * 80

            alpha_steps.each do |key, color|
              display_color(key, key, color)
            end
          end
        end

        def display_color(step, role, color)
          hex = color.to_hex(include_alpha: true)
          rgba = color.to_rgba

          # Create colored box (using ANSI escape codes)
          # Background color
          bg_code = "\e[48;2;#{color.r};#{color.g};#{color.b}m"
          reset = "\e[0m"
          box = "#{bg_code}      #{reset}"

          printf("  %2s %-15s %s  %-15s  %s\n", step, role, box, hex, rgba)
        end
      end
    end
  end
end
