# frozen_string_literal: true

require "huebrew/exporters/fzf/v1"

RSpec.describe Huebrew::Exporters::FZF::V1 do
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
    it "renders FZF color configuration" do
      result = exporter.render(palette: palette)

      expect(result).to be_a(String)
      expect(result).to start_with("export FZF_DEFAULT_OPTS=")
      expect(result).to include("--color=")
    end

    it "includes all required FZF color names" do
      result = exporter.render(palette: palette)

      %w[fg bg hl fg+ bg+ hl+ info prompt pointer marker spinner header border label query].each do |name|
        expect(result).to include("#{name}:")
      end
    end

    it "uses hex color format" do
      result = exporter.render(palette: palette)

      # Should contain hex colors like #FCFCFD
      expect(result).to match(/#[0-9A-F]{6}/)
    end

    it "maps roles correctly" do
      result = exporter.render(palette: palette)

      # Check some specific mappings
      # fg should be text (step 12)
      expect(result).to include("fg:#1C2024")

      # bg should be bg (step 1)
      expect(result).to include("bg:#FCFCFD")

      # hl should be solid (step 9)
      expect(result).to include("hl:#8B8D98")
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
