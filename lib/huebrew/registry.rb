# frozen_string_literal: true

require_relative "palette"
require_relative "errors"

module Huebrew
  # Registry for managing palettes and variants
  class Registry
    def initialize(data_dirs: nil)
      @data_dirs = data_dirs || default_data_dirs
      @palettes = {}
      @variants = {}
    end

    # Load all palettes from data directories
    def load_palettes!
      @palettes.clear

      @data_dirs.each do |dir|
        radix_dir = File.join(dir, "radix_v3")
        next unless Dir.exist?(radix_dir)

        Dir.glob(File.join(radix_dir, "*.yml")).each do |file|
          palette = Palette.load_from_file(file)
          @palettes[palette.id] = palette
        end
      end

      @palettes
    end

    # Get a palette by ID
    # @param id [String] Palette ID (e.g., "radix:slate:light")
    # @return [Palette, nil]
    def palette(id)
      load_palettes! if @palettes.empty?
      @palettes[id]
    end

    # List all available palettes
    # @return [Array<Palette>]
    def palettes
      load_palettes! if @palettes.empty?
      @palettes.values
    end

    # Find palettes matching criteria
    # @param family [String, nil] Family name to filter by
    # @param scheme [String, nil] Scheme to filter by ("light" or "dark")
    # @return [Array<Palette>]
    def find_palettes(family: nil, scheme: nil)
      results = palettes

      results = results.select { |p| p.families.key?(family) } if family
      results = results.select { |p| p.scheme == scheme } if scheme

      results
    end

    private

    def default_data_dirs
      dirs = []

      # Gem data directory
      gem_data = File.expand_path("../../data/palettes", __dir__)
      dirs << gem_data if Dir.exist?(gem_data)

      # User data directory
      user_data = File.join(Dir.home, ".huebrew", "palettes")
      dirs << user_data if Dir.exist?(user_data)

      dirs
    end
  end
end
