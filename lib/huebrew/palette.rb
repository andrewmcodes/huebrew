# frozen_string_literal: true

require "dry-struct"
require "yaml"
require_relative "types"
require_relative "color"
require_relative "errors"

module Huebrew
  # Represents a color palette with families and steps
  class Palette < Dry::Struct
    attribute :id, Types::String
    attribute :name, Types::String
    attribute :scheme, Types::Scheme
    attribute :families, Types::Hash.map(Types::String, Types::Hash)

    # Role to step mapping (Radix v3 taxonomy)
    ROLE_STEP_MAP = {
      "bg" => 1,
      "bgSubtle" => 2,
      "surface" => 3,
      "surfaceHover" => 4,
      "surfaceActive" => 5,
      "borderSubtle" => 6,
      "border" => 7,
      "borderHover" => 8,
      "solid" => 9,
      "solidHover" => 10,
      "textMuted" => 11,
      "text" => 12
    }.freeze

    # Semantic alias mapping
    SEMANTIC_ALIASES = {
      "neutral" => "slate",
      "accent" => "blue",
      "success" => "grass",
      "warning" => "amber",
      "danger" => "red",
      "info" => "cyan"
    }.freeze

    # Load palette from YAML file
    # @param path [String] Path to YAML file
    # @return [Palette]
    def self.load_from_file(path)
      raise NotFoundError, "Palette file not found: #{path}" unless File.exist?(path)

      data = YAML.load_file(path)
      family_name = data["family"]
      scheme = data["scheme"]

      # Parse color steps
      steps = {}
      (1..12).each do |i|
        hex = data["steps"][i] || data["steps"][i.to_s]
        raise SchemaError, "Missing step #{i} in palette #{path}" unless hex
        steps[i] = Color.parse(hex)
      end

      # Parse alpha steps if present
      alpha_steps = {}
      if data["alpha_steps"]
        (1..12).each do |i|
          key = "a#{i}"
          hex = data["alpha_steps"][key]
          alpha_steps[key] = Color.parse(hex) if hex
        end
      end

      # Create family hash
      families = {
        family_name => {
          "steps" => steps,
          "alpha_steps" => alpha_steps
        }
      }

      id = "radix:#{family_name}:#{scheme}"
      name = "Radix #{family_name.capitalize} (#{scheme.capitalize})"

      new(id: id, name: name, scheme: scheme, families: families)
    end

    # Get color for a role in a family
    # @param family [String] Family name (or semantic alias)
    # @param role [String] Role name
    # @param alpha [Boolean] Whether to use alpha variant
    # @return [Color, nil]
    def color_for_role(family, role, alpha: false)
      # Resolve semantic alias
      family = SEMANTIC_ALIASES[family] || family

      family_data = families[family]
      return nil unless family_data

      step = ROLE_STEP_MAP[role]
      return nil unless step

      if alpha && family_data["alpha_steps"]
        family_data["alpha_steps"]["a#{step}"]
      else
        family_data["steps"][step]
      end
    end

    # Get all roles for a family
    # @param family [String] Family name
    # @return [Hash] Role name to color mapping
    def roles_for_family(family)
      result = {}
      ROLE_STEP_MAP.each do |role, _step|
        color = color_for_role(family, role)
        result[role] = color if color
      end
      result
    end

    # Validate palette structure
    # @return [Boolean]
    def valid?
      families.all? do |_name, data|
        steps = data["steps"]
        next false unless steps

        (1..12).all? { |i| steps[i].is_a?(Color) }
      end
    end
  end
end
