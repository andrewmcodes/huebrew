# frozen_string_literal: true

require "dry-struct"
require_relative "types"
require_relative "errors"

module Huebrew
  # Represents an RGBA color with operations
  class Color < Dry::Struct
    attribute :r, Types::ColorComponent
    attribute :g, Types::ColorComponent
    attribute :b, Types::ColorComponent
    attribute :a, Types::Alpha.default(1.0)

    # Parse a hex color string into a Color instance
    # @param hex [String] Hex color string (#rgb, #rrggbb, #rrggbbaa)
    # @return [Color]
    def self.parse(hex)
      raise ParseError, "Invalid hex color format" unless hex.match?(/\A#[0-9a-fA-F]{3}(?:[0-9a-fA-F]{3}(?:[0-9a-fA-F]{2})?)?\z/)

      hex = hex.delete("#")

      # Expand shorthand notation (#rgb -> #rrggbb)
      if hex.length == 3
        hex = hex.chars.map { |c| c * 2 }.join
      end

      r = hex[0..1].to_i(16)
      g = hex[2..3].to_i(16)
      b = hex[4..5].to_i(16)
      a = (hex.length == 8) ? hex[6..7].to_i(16) / 255.0 : 1.0

      new(r: r, g: g, b: b, a: a)
    end

    # Convert color to hex string
    # @param include_alpha [Boolean] Whether to include alpha channel
    # @return [String]
    def to_hex(include_alpha: false)
      hex = "#%02X%02X%02X" % [r, g, b]
      hex += "%02X" % (a * 255).round if include_alpha && a < 1.0
      hex
    end

    # Convert color to rgba() string
    # @return [String]
    def to_rgba
      "rgba(#{r},#{g},#{b},#{a})"
    end

    # Create a new color with a different alpha value
    # @param new_alpha [Float] New alpha value (0.0-1.0)
    # @return [Color]
    def with_alpha(new_alpha)
      new(a: new_alpha)
    end

    # Blend this color over a background color
    # @param bg [Color] Background color
    # @return [Color]
    def blend_over(bg)
      return self if (a - 1.0).abs < 0.001

      # Alpha compositing formula
      out_a = a + bg.a * (1.0 - a)
      return bg if out_a.abs < 0.001

      out_r = ((r * a + bg.r * bg.a * (1.0 - a)) / out_a).round
      out_g = ((g * a + bg.g * bg.a * (1.0 - a)) / out_a).round
      out_b = ((b * a + bg.b * bg.a * (1.0 - a)) / out_a).round

      Color.new(r: out_r, g: out_g, b: out_b, a: out_a)
    end

    # Calculate relative luminance for contrast ratio
    # @return [Float]
    def relative_luminance
      rgb = [r, g, b].map do |component|
        normalized = component / 255.0
        if normalized <= 0.03928
          normalized / 12.92
        else
          ((normalized + 0.055) / 1.055)**2.4
        end
      end
      0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]
    end

    # Calculate contrast ratio with another color
    # @param other [Color] Other color
    # @return [Float]
    def contrast_ratio(other)
      l1 = relative_luminance
      l2 = other.relative_luminance

      lighter = [l1, l2].max
      darker = [l1, l2].min

      (lighter + 0.05) / (darker + 0.05)
    end

    # Ensure minimum contrast ratio with background
    # @param bg [Color] Background color
    # @param min_ratio [Float] Minimum contrast ratio (WCAG AA is 4.5)
    # @param strategy [Symbol] Strategy to use (:lighten or :darken)
    # @return [Color]
    def ensure_contrast(bg, min_ratio: 4.5, strategy: :auto)
      current_ratio = contrast_ratio(bg)
      return self if current_ratio >= min_ratio

      # Determine strategy if auto
      if strategy == :auto
        strategy = (relative_luminance > bg.relative_luminance) ? :lighten : :darken
      end

      # Adjust color to meet contrast ratio
      adjusted = self
      step = (strategy == :lighten) ? 5 : -5

      50.times do
        break if adjusted.contrast_ratio(bg) >= min_ratio

        new_r = (adjusted.r + step).clamp(0, 255)
        new_g = (adjusted.g + step).clamp(0, 255)
        new_b = (adjusted.b + step).clamp(0, 255)

        adjusted = Color.new(r: new_r, g: new_g, b: new_b, a: a)
      end

      adjusted
    end

    # String representation
    # @return [String]
    def to_s
      to_hex(include_alpha: a < 1.0)
    end
  end
end
