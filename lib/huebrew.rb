# frozen_string_literal: true

require_relative "huebrew/version"
require_relative "huebrew/errors"
require_relative "huebrew/types"
require_relative "huebrew/config"
require_relative "huebrew/color"

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
end

