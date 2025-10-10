# frozen_string_literal: true

require "dry-struct"
require_relative "types"

module Huebrew
  # Represents a variant transformation applied to a palette
  class Variant < Dry::Struct
    attribute :id, Types::String
    attribute :name, Types::String
    attribute :rules, Types::Array.of(Types::Hash)

    # Built-in variant definitions
    VARIANTS = {
      "base" => {
        id: "base",
        name: "Base",
        rules: []
      },
      "dim" => {
        id: "dim",
        name: "Dimmed",
        rules: [
          {type: "adjust_brightness", amount: -0.1},
          {type: "adjust_saturation", amount: -0.05}
        ]
      },
      "high_contrast" => {
        id: "high_contrast",
        name: "High Contrast",
        rules: [
          {type: "ensure_contrast", min_ratio: 7.0},
          {type: "boost_saturation", amount: 0.1}
        ]
      }
    }.freeze

    # Get variant by ID
    # @param id [String] Variant ID
    # @return [Variant, nil]
    def self.get(id)
      definition = VARIANTS[id]
      return nil unless definition

      new(
        id: definition[:id],
        name: definition[:name],
        rules: definition[:rules]
      )
    end

    # List all available variants
    # @return [Array<Variant>]
    def self.all
      VARIANTS.keys.map { |id| get(id) }
    end

    # Apply this variant to a palette
    # @param palette [Palette] Palette to transform
    # @return [Palette] Transformed palette (for now returns original)
    def apply(palette)
      # TODO: Implement actual transformation logic
      # For now, return the palette unchanged
      # Future: Apply rules to transform colors
      palette
    end

    # Apply specific rule to a color
    # @param color [Color] Color to transform
    # @param rule [Hash] Rule definition
    # @return [Color] Transformed color
    def apply_rule(color, rule)
      # Future implementation: transform colors based on rule type
      # For now, return unchanged
      color
    end
  end
end
