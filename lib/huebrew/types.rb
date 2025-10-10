# frozen_string_literal: true

require "dry-types"

module Huebrew
  module Types
    include Dry.Types()

    # Base types
    String = Types::String
    Integer = Types::Integer
    Float = Types::Float
    Bool = Types::Bool
    Hash = Types::Hash
    Array = Types::Array

    # Color component (0-255)
    ColorComponent = Types::Integer.constrained(gteq: 0, lteq: 255)

    # Alpha value (0.0-1.0)
    Alpha = Types::Float.constrained(gteq: 0.0, lteq: 1.0)

    # Hex color string
    HexColor = Types::String.constrained(format: /\A#[0-9a-fA-F]{3}(?:[0-9a-fA-F]{3}(?:[0-9a-fA-F]{2})?)?\z/)

    # Color scheme
    Scheme = Types::String.enum("light", "dark")

    # Alpha mode
    AlphaMode = Types::String.enum("preserve", "flatten", "strip")

    # Step number (1-12)
    Step = Types::Integer.constrained(gteq: 1, lteq: 12)

    # Family names
    FamilyName = Types::String

    # Role names
    RoleName = Types::String.enum(
      "bg", "bgSubtle", "surface", "surfaceHover", "surfaceActive",
      "borderSubtle", "border", "borderHover", "solid", "solidHover",
      "textMuted", "text"
    )

    # Semantic aliases
    SemanticAlias = Types::String.enum("neutral", "accent", "success", "warning", "danger", "info")
  end
end
