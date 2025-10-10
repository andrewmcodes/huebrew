# frozen_string_literal: true

RSpec.describe Huebrew::Registry do
  let(:data_dir) { File.join(__dir__, "..", "data", "palettes") }
  let(:registry) { described_class.new(data_dirs: [data_dir]) }

  describe "#load_palettes!" do
    it "loads palettes from data directories" do
      palettes = registry.load_palettes!
      expect(palettes).to be_a(Hash)
      expect(palettes).not_to be_empty
    end

    it "loads both light and dark variants" do
      registry.load_palettes!
      expect(registry.palette("radix:slate:light")).not_to be_nil
      expect(registry.palette("radix:slate:dark")).not_to be_nil
    end
  end

  describe "#palette" do
    it "returns palette by ID" do
      palette = registry.palette("radix:slate:light")
      expect(palette).to be_a(Huebrew::Palette)
      expect(palette.id).to eq("radix:slate:light")
    end

    it "returns nil for unknown palette" do
      palette = registry.palette("nonexistent:palette:light")
      expect(palette).to be_nil
    end
  end

  describe "#palettes" do
    it "returns all loaded palettes" do
      palettes = registry.palettes
      expect(palettes).to be_an(Array)
      expect(palettes.first).to be_a(Huebrew::Palette)
    end
  end

  describe "#find_palettes" do
    it "finds palettes by family" do
      results = registry.find_palettes(family: "slate")
      expect(results).not_to be_empty
      expect(results.all? { |p| p.families.key?("slate") }).to be true
    end

    it "finds palettes by scheme" do
      results = registry.find_palettes(scheme: "light")
      expect(results).not_to be_empty
      expect(results.all? { |p| p.scheme == "light" }).to be true
    end

    it "finds palettes by both family and scheme" do
      results = registry.find_palettes(family: "slate", scheme: "dark")
      expect(results).not_to be_empty
      expect(results.all? { |p| p.families.key?("slate") && p.scheme == "dark" }).to be true
    end
  end
end
