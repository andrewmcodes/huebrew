# frozen_string_literal: true

RSpec.describe Huebrew::Palette do
  let(:palette_path) { File.join(__dir__, "..", "data", "palettes", "radix_v3", "slate_light.yml") }
  let(:palette) { described_class.load_from_file(palette_path) }

  describe ".load_from_file" do
    it "loads palette from YAML file" do
      expect(palette).to be_a(Huebrew::Palette)
      expect(palette.id).to eq("radix:slate:light")
      expect(palette.scheme).to eq("light")
    end

    it "parses all 12 steps" do
      family_data = palette.families["slate"]
      expect(family_data["steps"].size).to eq(12)

      (1..12).each do |i|
        expect(family_data["steps"][i]).to be_a(Huebrew::Color)
      end
    end

    it "parses alpha steps" do
      family_data = palette.families["slate"]
      expect(family_data["alpha_steps"]).not_to be_empty

      (1..12).each do |i|
        key = "a#{i}"
        expect(family_data["alpha_steps"][key]).to be_a(Huebrew::Color)
      end
    end

    it "raises error for missing file" do
      expect {
        described_class.load_from_file("/nonexistent/file.yml")
      }.to raise_error(Huebrew::NotFoundError)
    end
  end

  describe "#color_for_role" do
    it "returns color for bg role (step 1)" do
      color = palette.color_for_role("slate", "bg")
      expect(color).to be_a(Huebrew::Color)
      expect(color.to_hex).to eq("#FCFCFD")
    end

    it "returns color for text role (step 12)" do
      color = palette.color_for_role("slate", "text")
      expect(color).to be_a(Huebrew::Color)
      expect(color.to_hex).to eq("#1C2024")
    end

    it "returns alpha variant when requested" do
      color = palette.color_for_role("slate", "bg", alpha: true)
      expect(color).to be_a(Huebrew::Color)
      # Alpha step a1 should have some transparency
      expect(color.a).to be < 1.0
    end

    it "returns nil for unknown family" do
      color = palette.color_for_role("unknown", "bg")
      expect(color).to be_nil
    end

    it "returns nil for unknown role" do
      color = palette.color_for_role("slate", "unknown")
      expect(color).to be_nil
    end
  end

  describe "#roles_for_family" do
    it "returns all roles for a family" do
      roles = palette.roles_for_family("slate")
      expect(roles).to be_a(Hash)
      expect(roles.keys).to include("bg", "text", "solid")
      expect(roles.size).to eq(12)
    end
  end

  describe "#valid?" do
    it "returns true for valid palette" do
      expect(palette.valid?).to be true
    end
  end

  describe "ROLE_STEP_MAP" do
    it "maps all 12 roles to steps" do
      expect(described_class::ROLE_STEP_MAP.size).to eq(12)
      expect(described_class::ROLE_STEP_MAP["bg"]).to eq(1)
      expect(described_class::ROLE_STEP_MAP["text"]).to eq(12)
    end
  end

  describe "SEMANTIC_ALIASES" do
    it "defines semantic color mappings" do
      expect(described_class::SEMANTIC_ALIASES["neutral"]).to eq("slate")
      expect(described_class::SEMANTIC_ALIASES["danger"]).to eq("red")
    end
  end
end
