## [Unreleased]

### Added
- **Variant system**: Base, dim, and high_contrast variants with transformation rules
- **Theme resolver**: Bridge between palette + variant for token resolution
- **Build command**: Preview resolved themes with all tokens (YAML/JSON output)
- **Tmux exporter**: Generate tmux.conf color configurations
- **Template system**: ERB template rendering for file-based exporters
- **8 additional Radix v3 families**: blue, cyan, amber, orange (16 total palettes)
- **Semantic palette completeness**: All 8 families mapped (neutral, accent, success, warning, danger, info)

### Changed
- List variants now shows actual variant definitions with rule counts
- Export command supports tmux target
- Improved documentation with variant usage and expanded palette list

## [0.1.0] - 2025-10-10

### Added
- Core color model with RGBA support, parsing, and formatting
- Color operations: alpha blending, contrast ratio calculation, WCAG validation
- Configuration system with multi-layer support (defaults, YAML, ENV, CLI flags)
- Radix v3 palette loader with role taxonomy
- Palette registry for discovery and management
- Exporter framework with capability system
- FZF exporter with alpha flattening and role mapping
- CLI with 5 commands: version, init, list, preview, export
- 8 Radix v3 color palettes (slate, violet, grass, red in light/dark)
- Comprehensive test suite with 57 passing tests
- Full documentation in README
- StandardRB linting compliance
