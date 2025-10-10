# frozen_string_literal: true

require_relative "../command"
require_relative "../../exporters/fzf/v1"

module Huebrew
  module CLI
    module Commands
      # Export palette to different formats
      class Export < Command
        desc "Export a palette to a specific format"

        argument :target, type: :string, required: true, desc: "Export target (fzf, vscode, tmux, neovim, raycast)"
        argument :palette_id, type: :string, required: false, desc: "Palette ID (e.g., radix:slate:light)"

        option :family, type: :string, desc: "Family to export (defaults to first family)"
        option :output, aliases: ["o"], type: :string, desc: "Output file path"

        def call(target:, palette_id: nil, family: nil, output: nil, **)
          palette_id ||= Huebrew.config.default_palette
          palette = Huebrew.registry.palette(palette_id)

          unless palette
            warn "Palette not found: #{palette_id}"
            warn "Run 'huebrew list palettes' to see available palettes"
            exit(3)
          end

          exporter = get_exporter(target)

          unless exporter
            warn "Unknown export target: #{target}"
            warn "Run 'huebrew list exporters' to see available exporters"
            exit(3)
          end

          result = exporter.render(palette: palette, family: family, dest: output)

          case exporter.output_kind
          when :string
            if output
              File.write(output, result)
              puts "Exported to: #{output}"
            else
              puts result
            end
          when :file
            puts "Exported to: #{result}"
          when :dir
            puts "Exported to directory: #{result}"
          end
        rescue => e
          handle_error(e)
        end

        private

        def get_exporter(target)
          case target
          when "fzf"
            Huebrew::Exporters::FZF::V1.new
          end
        end
      end
    end
  end
end
