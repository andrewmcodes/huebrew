# frozen_string_literal: true

require "dry-configurable"
require "yaml"

module Huebrew
  # Global configuration for Huebrew
  class Config
    extend Dry::Configurable

    # Data directory (default: gem data + ~/.huebrew/palettes)
    setting :data_dir, default: -> { default_data_dir }

    # Templates directory (default: gem templates + ~/.huebrew/templates)
    setting :templates_dir, default: -> { default_templates_dir }

    # Cache directory (~/.huebrew/cache)
    setting :cache_dir, default: -> { File.join(user_huebrew_dir, "cache") }

    # Default palette (radix:slate:light)
    setting :default_palette, default: "radix:slate:light"

    # Default variant (base)
    setting :default_variant, default: "base"

    # Alpha mode (preserve|flatten|strip)
    setting :alpha_mode, default: "preserve"

    # Fail on contrast violation
    setting :fail_on_contrast_violation, default: true

    class << self
      # Load configuration from YAML file
      # @param path [String] Path to configuration file
      def load_from_file(path)
        return unless File.exist?(path)

        yaml = YAML.load_file(path)
        yaml.each do |key, value|
          config.public_send(:"#{key}=", value) if config.respond_to?(:"#{key}=")
        end
      end

      # Load configuration from environment variables
      def load_from_env
        config.data_dir = ENV["HUEBREW_DATA_DIR"] if ENV["HUEBREW_DATA_DIR"]
        config.templates_dir = ENV["HUEBREW_TEMPLATES_DIR"] if ENV["HUEBREW_TEMPLATES_DIR"]
        config.cache_dir = ENV["HUEBREW_CACHE_DIR"] if ENV["HUEBREW_CACHE_DIR"]
        config.default_palette = ENV["HUEBREW_DEFAULT_PALETTE"] if ENV["HUEBREW_DEFAULT_PALETTE"]
        config.default_variant = ENV["HUEBREW_DEFAULT_VARIANT"] if ENV["HUEBREW_DEFAULT_VARIANT"]
        config.alpha_mode = ENV["HUEBREW_ALPHA_MODE"] if ENV["HUEBREW_ALPHA_MODE"]
        config.fail_on_contrast_violation = ENV["HUEBREW_FAIL_ON_CONTRAST_VIOLATION"] == "true" if ENV["HUEBREW_FAIL_ON_CONTRAST_VIOLATION"]
      end

      # Initialize configuration with default layer precedence
      def initialize_config
        # Load from user config file if exists
        user_config_path = File.join(user_huebrew_dir, "config.yml")
        load_from_file(user_config_path)

        # Load from environment
        load_from_env
      end

      private

      def user_huebrew_dir
        File.join(Dir.home, ".huebrew")
      end

      def default_data_dir
        gem_data_dir = File.expand_path("../../data/palettes", __dir__)
        user_data_dir = File.join(user_huebrew_dir, "palettes")

        [gem_data_dir, user_data_dir].select { |dir| Dir.exist?(dir) }
      end

      def default_templates_dir
        gem_templates_dir = File.expand_path("../../templates", __dir__)
        user_templates_dir = File.join(user_huebrew_dir, "templates")

        [gem_templates_dir, user_templates_dir].select { |dir| Dir.exist?(dir) }
      end
    end
  end
end
