# frozen_string_literal: true

RSpec.describe Huebrew::Color do
  describe ".parse" do
    it "parses 3-digit hex colors" do
      color = described_class.parse("#abc")
      expect(color.r).to eq(170)
      expect(color.g).to eq(187)
      expect(color.b).to eq(204)
      expect(color.a).to eq(1.0)
    end

    it "parses 6-digit hex colors" do
      color = described_class.parse("#1a2b3c")
      expect(color.r).to eq(26)
      expect(color.g).to eq(43)
      expect(color.b).to eq(60)
      expect(color.a).to eq(1.0)
    end

    it "parses 8-digit hex colors with alpha" do
      color = described_class.parse("#1a2b3c80")
      expect(color.r).to eq(26)
      expect(color.g).to eq(43)
      expect(color.b).to eq(60)
      expect(color.a).to be_within(0.01).of(0.5)
    end

    it "raises error for invalid hex format" do
      expect { described_class.parse("invalid") }.to raise_error(Huebrew::ParseError)
    end
  end

  describe "#to_hex" do
    it "converts to 6-digit hex without alpha" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 1.0)
      expect(color.to_hex).to eq("#1A2B3C")
    end

    it "converts to 8-digit hex with alpha when requested" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 0.5)
      expect(color.to_hex(include_alpha: true)).to eq("#1A2B3C80")
    end

    it "omits alpha when alpha is 1.0 even if requested" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 1.0)
      expect(color.to_hex(include_alpha: true)).to eq("#1A2B3C")
    end
  end

  describe "#to_rgba" do
    it "converts to rgba() string" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 0.5)
      expect(color.to_rgba).to eq("rgba(26,43,60,0.5)")
    end
  end

  describe "#with_alpha" do
    it "creates a new color with different alpha" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 1.0)
      new_color = color.with_alpha(0.5)

      expect(new_color.r).to eq(26)
      expect(new_color.g).to eq(43)
      expect(new_color.b).to eq(60)
      expect(new_color.a).to eq(0.5)
    end
  end

  describe "#blend_over" do
    it "blends transparent color over opaque background" do
      fg = described_class.new(r: 255, g: 0, b: 0, a: 0.5)
      bg = described_class.new(r: 0, g: 0, b: 255, a: 1.0)

      result = fg.blend_over(bg)

      expect(result.r).to be_within(1).of(128)
      expect(result.g).to eq(0)
      expect(result.b).to be_within(1).of(128)
    end

    it "returns self if alpha is 1.0" do
      fg = described_class.new(r: 255, g: 0, b: 0, a: 1.0)
      bg = described_class.new(r: 0, g: 0, b: 255, a: 1.0)

      result = fg.blend_over(bg)

      expect(result).to eq(fg)
    end
  end

  describe "#relative_luminance" do
    it "calculates luminance for white" do
      white = described_class.new(r: 255, g: 255, b: 255, a: 1.0)
      expect(white.relative_luminance).to be_within(0.01).of(1.0)
    end

    it "calculates luminance for black" do
      black = described_class.new(r: 0, g: 0, b: 0, a: 1.0)
      expect(black.relative_luminance).to be_within(0.01).of(0.0)
    end
  end

  describe "#contrast_ratio" do
    it "calculates contrast ratio between black and white" do
      black = described_class.new(r: 0, g: 0, b: 0, a: 1.0)
      white = described_class.new(r: 255, g: 255, b: 255, a: 1.0)

      ratio = black.contrast_ratio(white)
      expect(ratio).to be_within(0.1).of(21.0)
    end

    it "calculates contrast ratio of 1 for same colors" do
      color = described_class.new(r: 128, g: 128, b: 128, a: 1.0)

      ratio = color.contrast_ratio(color)
      expect(ratio).to be_within(0.01).of(1.0)
    end
  end

  describe "#ensure_contrast" do
    it "adjusts color to meet minimum contrast ratio" do
      fg = described_class.new(r: 100, g: 100, b: 100, a: 1.0)
      bg = described_class.new(r: 120, g: 120, b: 120, a: 1.0)

      adjusted = fg.ensure_contrast(bg, min_ratio: 4.5)

      expect(adjusted.contrast_ratio(bg)).to be >= 4.5
    end

    it "does not adjust if contrast is already sufficient" do
      fg = described_class.new(r: 0, g: 0, b: 0, a: 1.0)
      bg = described_class.new(r: 255, g: 255, b: 255, a: 1.0)

      adjusted = fg.ensure_contrast(bg, min_ratio: 4.5)

      expect(adjusted).to eq(fg)
    end
  end

  describe "#to_s" do
    it "returns hex representation" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 1.0)
      expect(color.to_s).to eq("#1A2B3C")
    end

    it "includes alpha in string when less than 1.0" do
      color = described_class.new(r: 26, g: 43, b: 60, a: 0.5)
      expect(color.to_s).to eq("#1A2B3C80")
    end
  end
end
