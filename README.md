# Huebrew

A Ruby gem that centralizes Radix v3 color palettes and provides a CLI to build and export themes to multiple targets (fzf, VS Code, tmux, Neovim, Raycast).

## Features

- 🎨 **Radix v3 Color Palettes**: Built-in support for Radix color system v3
- 🔧 **Flexible Configuration**: Highly configurable with YAML, environment variables, and CLI flags
- 🎯 **Multiple Export Targets**: Export to FZF, VS Code, tmux, Neovim, and Raycast
- 🌈 **Alpha Channel Support**: Proper RGBA color handling with alpha blending
- ♿ **Accessibility**: WCAG contrast ratio validation
- 🚀 **CLI Interface**: Powerful command-line interface for theme management

## Installation

Add this line to your application's Gemfile:

```bash
bundle add huebrew
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install huebrew
```

## Usage

### Initialize Huebrew

Create the configuration directory and files:

```bash
huebrew init
```

This creates `~/.huebrew/` with directories for palettes, templates, cache, and themes.

### List Available Resources

List all available palettes:

```bash
huebrew list palettes
```

List available variants:

```bash
huebrew list variants
```

List available exporters:

```bash
huebrew list exporters
```

### Preview Palettes

Preview a palette in your terminal with color boxes:

```bash
huebrew preview radix:slate:light
huebrew preview radix:violet:dark
```

### Export Themes

Export a palette to FZF format:

```bash
# Print to stdout
huebrew export fzf radix:slate:dark

# Export to file
huebrew export fzf radix:slate:dark -o ~/.fzf_colors.sh
```

Export a palette to tmux format:

```bash
# Export tmux configuration
huebrew export tmux radix:violet:dark -o ~/.tmux-colors.conf

# Source in your .tmux.conf
# source-file ~/.tmux-colors.conf
```

Then source it in your shell:

```bash
source ~/.fzf_colors.sh
```

### Build Themes

Preview the resolved theme with all tokens:

```bash
# Build theme in YAML format
huebrew build radix:slate:light

# Build with variant
huebrew build radix:slate:light --variant dim

# Build in JSON format
huebrew build radix:slate:light --format json

# Show only specific family
huebrew build radix:slate:light --family slate
```

## Configuration

Edit `~/.huebrew/config.yml` to customize settings:

```yaml
# Default palette (format: source:family:scheme)
default_palette: "radix:slate:light"

# Default variant
default_variant: "base"

# Alpha handling mode (preserve, flatten, strip)
alpha_mode: "preserve"

# Fail on WCAG contrast violations
fail_on_contrast_violation: true
```

Configuration can also be set via environment variables:

```bash
export HUEBREW_DEFAULT_PALETTE="radix:violet:dark"
export HUEBREW_ALPHA_MODE="flatten"
```

## Color Palettes

### Radix v3 Palettes Included

All palettes are available in both light and dark schemes:

**Core Palettes:**
- **Slate** (neutral) - Gray scale for UI
- **Violet** (accent) - Purple for primary actions
- **Blue** (info) - Blue for informational elements
- **Cyan** (info alt) - Cyan for secondary info

**Semantic Palettes:**
- **Grass** (success) - Green for success states
- **Amber** (warning) - Amber for warnings
- **Orange** (warning alt) - Orange for secondary warnings
- **Red** (danger) - Red for errors and destructive actions

Total: **16 complete color palettes** (8 families × 2 schemes)

### Variants

Three built-in variant transformations:

- **base** - Default colors (no transformation)
- **dim** - Slightly dimmed colors for reduced contrast
- **high_contrast** - Enhanced colors for better accessibility

Use variants with the `--variant` flag in build and export commands.

Huebrew uses a canonical RGBA color model:

- **Parsing**: Supports `#rgb`, `#rrggbb`, `#rrggbbaa` formats
- **Formatting**: Outputs as hex or rgba() strings
- **Operations**: Alpha blending, contrast ratio calculation, WCAG validation

## Radix v3 Palettes

Built-in support for Radix color system v3 with:

- 12-step color scales (1-12)
- Alpha variants (a1-a12)
- Light and dark schemes
- Role-based taxonomy (bg, surface, border, solid, text, etc.)

### Role Taxonomy

Each palette defines semantic roles:

- `bg` → Step 1 (Background)
- `bgSubtle` → Step 2
- `surface` → Step 3
- `surfaceHover` → Step 4
- `surfaceActive` → Step 5
- `borderSubtle` → Step 6
- `border` → Step 7
- `borderHover` → Step 8
- `solid` → Step 9 (Primary/Accent)
- `solidHover` → Step 10
- `textMuted` → Step 11
- `text` → Step 12 (Primary text)

## CLI Commands

### `huebrew version`

Display version information.

### `huebrew init`

Initialize the ~/.huebrew directory structure and create a sample configuration file.

### `huebrew list [type]`

List available resources. Type can be:
- `palettes` - Show all available color palettes
- `variants` - Show variant transformations
- `exporters` - Show export targets

### `huebrew preview [palette_id]`

Preview a color palette in the terminal with colored output.

Options:
- `--family` - Specify which family to preview

### `huebrew build [palette_id]`

Build and preview a theme with all resolved tokens.

Options:
- `--variant` - Apply variant transformation (base, dim, high_contrast)
- `--format` - Output format (yaml, json)
- `--family` - Show only tokens for specific family

### `huebrew export <target> [palette_id]`

Export a palette to a specific format.

Options:
- `--family` - Specify which family to export
- `-o, --output` - Output file path

Available targets:
- `fzf` - FZF color configuration (string output)
- `tmux` - tmux.conf color configuration (file output)
- More targets coming soon (vscode, neovim, raycast)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Type Checking

This gem includes RBS type signatures in the `sig/` directory. To validate the type signatures:

```bash
bundle exec rake rbs:validate
```

The RBS validation is automatically run as part of the default rake task and CI workflow.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andrewmcodes/huebrew. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/andrewmcodes/huebrew/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Huebrew project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/andrewmcodes/huebrew/blob/main/CODE_OF_CONDUCT.md).
