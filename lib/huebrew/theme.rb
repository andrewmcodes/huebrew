# frozen_string_literal: true

require_relative "palette"
require_relative "variant"

module Huebrew
  # Represents a resolved theme (palette + variant)
  class Theme
    attr_reader :palette, :variant, :tokens

    # Initialize a theme
    # @param palette [Palette] Base palette
    # @param variant [Variant, nil] Optional variant transformation
    def initialize(palette:, variant: nil)
      @palette = palette
      @variant = variant || Variant.get("base")
      @tokens = resolve_tokens
    end

    # Resolve all color tokens for this theme
    # @return [Hash] Token name to color mapping
    def resolve_tokens
      # Start with palette colors
      tokens = {}

      palette.families.each do |family_name, family_data|
        # Add step-based tokens
        family_data["steps"].each do |step, color|
          tokens["#{family_name}.#{step}"] = color
        end

        # Add role-based tokens
        Palette::ROLE_STEP_MAP.each do |role, step|
          color = family_data["steps"][step]
          tokens["#{family_name}.#{role}"] = color if color
        end

        # Add alpha tokens if present
        family_data["alpha_steps"]&.each do |key, color|
          tokens["#{family_name}.#{key}"] = color
        end
      end

      # Apply variant transformations
      tokens = apply_variant_rules(tokens) if variant&.rules&.any?

      tokens
    end

    # Get a color by token path
    # @param path [String] Token path (e.g., "slate.bg", "violet.9")
    # @return [Color, nil]
    def color(path)
      tokens[path]
    end

    # Get all tokens for a family
    # @param family [String] Family name
    # @return [Hash] Filtered tokens
    def tokens_for_family(family)
      tokens.select { |k, _v| k.start_with?("#{family}.") }
    end

    private

    def apply_variant_rules(tokens)
      # Apply each rule from the variant
      variant.rules.each do |rule|
        tokens = tokens.transform_values { |color| variant.apply_rule(color, rule) }
      end
      tokens
    end
  end
end
