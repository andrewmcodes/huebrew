# frozen_string_literal: true

require_relative "errors"

module Huebrew
  # Base class for exporters
  class Exporter
    attr_reader :id, :name, :output_kind

    def initialize
      @id = self.class.name.split("::").last.downcase
      @name = @id.capitalize
      @output_kind = :string # :string, :file, or :dir
    end

    # Capabilities of this exporter
    # @return [Hash]
    def capabilities
      {
        supports_alpha: true,
        wants_rgb: false,
        flatten_alpha: false
      }
    end

    # Render the theme using this exporter
    # @param palette [Palette] Palette to export
    # @param family [String] Family name to export
    # @param dest [String, nil] Destination path (for file/dir exporters)
    # @return [String, nil] Rendered output (for string exporters) or path (for file/dir exporters)
    def render(palette:, family: nil, dest: nil)
      raise NotImplementedError, "Subclass must implement #render"
    end

    protected

    # Format color based on exporter capabilities
    # @param color [Color] Color to format
    # @param bg [Color, nil] Background color (for alpha flattening)
    # @return [String]
    def format_color(color, bg: nil)
      # Flatten alpha if needed
      if capabilities[:flatten_alpha] && color.a < 1.0 && bg
        color = color.blend_over(bg)
      end

      # Return RGB format if requested
      if capabilities[:wants_rgb]
        color.to_rgba
      else
        # Strip alpha if not supported
        include_alpha = capabilities[:supports_alpha] && color.a < 1.0
        color.to_hex(include_alpha: include_alpha)
      end
    end
  end
end
