# frozen_string_literal: true

require_relative "lib/huebrew/version"

Gem::Specification.new do |spec|
  spec.name = "huebrew"
  spec.version = Huebrew::VERSION
  spec.authors = ["Andrew Mason"]
  spec.email = ["andrewmcodes@protonmail.com"]

  spec.summary = "Centralize Radix v3 color palettes, variants, and exporters"
  spec.description = "A Ruby gem that provides a CLI to build and export Radix v3 color themes to multiple targets (fzf, VS Code, tmux, Neovim, Raycast)"
  spec.homepage = "https://github.com/andrewmcodes/huebrew"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andrewmcodes/huebrew"
  spec.metadata["changelog_uri"] = "https://github.com/andrewmcodes/huebrew/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dry-cli", "~> 1.0"
  spec.add_dependency "dry-configurable", "~> 1.0"
  spec.add_dependency "dry-struct", "~> 1.6"
  spec.add_dependency "dry-types", "~> 1.7"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "aruba", "~> 2.0"
  spec.add_development_dependency "rbs", "~> 3.0"
  spec.add_dependency "simplecov", "~> 0.22"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
