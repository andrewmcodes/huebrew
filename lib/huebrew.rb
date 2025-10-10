# frozen_string_literal: true

require_relative "huebrew/version"
require_relative "huebrew/errors"
require_relative "huebrew/types"
require_relative "huebrew/config"
require_relative "huebrew/color"
require_relative "huebrew/palette"
require_relative "huebrew/registry"
require_relative "huebrew/exporter"

module Huebrew
  # Configure Huebrew
  # @yield [Config]
  def self.configure
    yield Config.config if block_given?
    Config.initialize_config
  end

  # Get current configuration
  def self.config
    Config.config
  end

  # Get global registry instance
  def self.registry
    @registry ||= Registry.new
  end
end
