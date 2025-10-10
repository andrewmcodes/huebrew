# frozen_string_literal: true

module Huebrew
  # Base error class
  class Error < StandardError; end

  # Configuration errors
  class ConfigError < Error; end

  # Schema validation errors
  class SchemaError < Error; end

  # Resource not found errors
  class NotFoundError < Error; end

  # Contrast violation errors
  class ContrastViolationError < Error; end

  # Parsing errors
  class ParseError < Error; end

  # Export errors
  class ExportError < Error; end
end
