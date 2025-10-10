# frozen_string_literal: true

RSpec.describe Huebrew::Config do
  describe "default settings" do
    it "has default alpha_mode of preserve" do
      expect(described_class.config.alpha_mode).to eq("preserve")
    end

    it "has default default_palette" do
      expect(described_class.config.default_palette).to eq("radix:slate:light")
    end

    it "has default default_variant" do
      expect(described_class.config.default_variant).to eq("base")
    end

    it "has fail_on_contrast_violation enabled by default" do
      expect(described_class.config.fail_on_contrast_violation).to be true
    end
  end

  describe ".load_from_env" do
    before do
      # Save original env vars
      @original_alpha_mode = ENV["HUEBREW_ALPHA_MODE"]
      @original_palette = ENV["HUEBREW_DEFAULT_PALETTE"]
      @original_fail = ENV["HUEBREW_FAIL_ON_CONTRAST_VIOLATION"]
    end

    after do
      # Restore original env vars
      ENV["HUEBREW_ALPHA_MODE"] = @original_alpha_mode
      ENV["HUEBREW_DEFAULT_PALETTE"] = @original_palette
      ENV["HUEBREW_FAIL_ON_CONTRAST_VIOLATION"] = @original_fail
    end

    it "loads alpha_mode from environment" do
      ENV["HUEBREW_ALPHA_MODE"] = "flatten"
      described_class.load_from_env

      expect(described_class.config.alpha_mode).to eq("flatten")
    end

    it "loads default_palette from environment" do
      ENV["HUEBREW_DEFAULT_PALETTE"] = "radix:blue:dark"
      described_class.load_from_env

      expect(described_class.config.default_palette).to eq("radix:blue:dark")
    end

    it "loads fail_on_contrast_violation from environment" do
      ENV["HUEBREW_FAIL_ON_CONTRAST_VIOLATION"] = "true"
      described_class.load_from_env

      expect(described_class.config.fail_on_contrast_violation).to be true
    end
  end
end
