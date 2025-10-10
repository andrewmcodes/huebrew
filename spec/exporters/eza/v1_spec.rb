# frozen_string_literal: true

require "huebrew/exporters/eza/v1"

RSpec.describe Huebrew::Exporters::Eza::V1 do
  let(:palette_path) { File.join(__dir__, "..", "..", "..", "data", "palettes", "radix_v3", "slate_light.yml") }
  let(:palette) { Huebrew::Palette.load_from_file(palette_path) }
  let(:exporter) { described_class.new }

  describe "#capabilities" do
    it "does not support alpha" do
      expect(exporter.capabilities[:supports_alpha]).to be false
    end

    it "requires alpha flattening" do
      expect(exporter.capabilities[:flatten_alpha]).to be true
    end

    it "does not want RGB format" do
      expect(exporter.capabilities[:wants_rgb]).to be false
    end
  end

  describe "#render" do
    it "renders Eza color configuration" do
      result = exporter.render(palette: palette)

      expect(result).to be_a(String)
      expect(result).to include("export EZA_COLORS=")
      expect(result).to include("# eza")
    end

    it "includes all required Eza color codes" do
      result = exporter.render(palette: palette)

      %w[uu uR un gu da ur uw ux ue gr gw gx tr tw tx xx].each do |code|
        expect(result).to include("#{code}=")
      end
    end

    it "uses ANSI color codes" do
      result = exporter.render(palette: palette)

      # Should contain ANSI codes (numbers)
      expect(result).to match(/uu=\d+/)
      expect(result).to match(/uR=\d+/)
    end

    it "uses multi-line format with backslash continuation" do
      result = exporter.render(palette: palette)

      expect(result).to include("\\")
      lines = result.split("\n")
      expect(lines.length).to be > 5 # Header + multiple color lines
    end

    it "includes palette name in header" do
      result = exporter.render(palette: palette)

      expect(result).to include(palette.name)
    end

    it "raises error for unknown family" do
      expect {
        exporter.render(palette: palette, family: "unknown")
      }.to raise_error(Huebrew::ExportError)
    end
  end

  describe "#output_kind" do
    it "is string output" do
      expect(exporter.output_kind).to eq(:string)
    end
  end
end
