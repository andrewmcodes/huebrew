# frozen_string_literal: true

target :lib do
  signature "sig"

  check "lib"

  library "pathname"
  library "yaml"

  # Ignore files that use dry-* DSL which Steep cannot properly analyze
  ignore "lib/huebrew/types.rb"
  ignore "lib/huebrew/palette.rb"
  ignore "lib/huebrew/variant.rb"
  ignore "lib/huebrew/color.rb"
  ignore "lib/huebrew/config.rb"
  ignore "lib/huebrew/cli.rb"

  # Ignore files with __dir__ false positives
  ignore "lib/huebrew/registry.rb"
  ignore "lib/huebrew/renderers/erb_renderer.rb"

  # Ignore CLI commands as they use Dry::CLI DSL extensively with kwrestarg syntax
  # that Steep cannot properly analyze
  ignore "lib/huebrew/cli/commands/**/*.rb"

  repo_path ".gem_rbs_collection/"
end
