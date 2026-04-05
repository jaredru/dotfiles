# Dotfiles

- **Purpose:** Personal development environment configuration (macOS, WSL)
- **Bootstrap:** `source bootstrap.sh` from a fresh machine sets up everything
- **Convention:** XDG Base Directory Specification throughout
- **Platforms:** macOS (primary), WSL (secondary)

## What This Repo Does

This is a dotfiles repository rooted at `$XDG_CONFIG_HOME` (~/.config). It bootstraps and configures a complete development environment: shell (zsh), editor (neovim), terminal emulators (Ghostty, Terminal.app), git, language runtimes (Node, Ruby, Go, Java), and CLI tools.

The bootstrap system is self-contained: clone the repo to ~/.config, run `bootstrap.sh`, and a new machine is fully configured.

## Directory Structure

| Directory | Purpose |
|-----------|---------|
| `zsh/` | Shell config: .zshrc, env vars, aliases, keybindings, vi mode, plugins (antidote) |
| `nvim/` | Neovim: init.vim, custom colorscheme (terminal.vim), statusline, tabline |
| `ghostty/` | Ghostty terminal: base24-twilight theme, font/keybind config |
| `terminal/` | macOS Terminal.app: base24-twilight theme, bootstrap plist setup |
| `git/` | Git config: aliases, delta pager, Kaleidoscope difftool, global ignore |
| `ruby/` | Ruby: gem config, gem bootstrap |
| `node/` | Node: npm aliases |
| `fonts/` | Font files: Consolas NF, Fira Code, Cascadia PL |
| `bat/` | bat config (base16 theme) |
| `sqlite/` | SQLite config (.sqliterc) |
| `npm/` | npm aliases |
| `claude/` | Claude Code env config |
| `jbx/` | jbx defaults |

## Bootstrap System

### Flow

1. `bootstrap.sh` detects OS (macOS, WSL, Linux)
2. Sets `XDG_CONFIG_HOME` and `XDG_CACHE_HOME` if unset
3. Clones/updates the dotfiles repo to `$XDG_CONFIG_HOME`
4. Symlinks all `*.symlink` files to `$HOME/.filename`
5. Runs platform-specific bootstrap (`bootstrap.mac.sh` or `bootstrap.wsl.sh`)
6. Auto-discovers and runs every `*/bootstrap.sh` in the config tree

### Symlink Convention

Files named `*.symlink` are symlinked to `$HOME/.basename` (without the `.symlink` suffix). Example: `zsh/zshenv.symlink` becomes `~/.zshenv`. The bootstrap handles re-runs: it fixes stale symlinks and warns on conflicts.

### Platform Bootstraps

- **`bootstrap.mac.sh`** — Installs Homebrew, cask apps (Ghostty, Firefox, VS Code, etc.), and brew formulas (neovim, node, ruby, bat, fd, fzf, ripgrep, etc.)
- **`bootstrap.wsl.sh`** — apt-get update, Homebrew for Linux, similar formulas without macOS-specific tools

### Per-Component Bootstraps

Each directory can have a `bootstrap.sh` that runs automatically:
- `nvim/bootstrap.sh` — runs `nvim +qall` to trigger vim.pack plugin installation
- `node/bootstrap.sh` — npm global update, installs chnode (guards against missing npm)
- `ruby/bootstrap.sh` — installs gems (cocoapods, fastlane, houston)
- `zsh/bootstrap.sh` — sets zsh as default shell
- `fonts/bootstrap.sh` — copies fonts to system font directory
- `terminal/bootstrap.sh` — runs platform-specific Terminal.app setup

## Key Conventions

### XDG Compliance

All paths follow XDG Base Directory:
- Config: `$XDG_CONFIG_HOME` (~/.config) — this repo
- Cache: `$XDG_CACHE_HOME` (~/.cache) — swap, undo, plugin caches
- Data: `$XDG_DATA_HOME` (~/.local/share) — neovim plugin installs (via vim.pack)

### Color Theme

The base24-twilight theme is used consistently across:
- Ghostty (`ghostty/themes/base24-twilight`) — 24 palette colors (0-23)
- Terminal.app (`terminal/Base24 Twilight.terminal`) — matching ANSI colors
- Neovim (`nvim/colors/terminal.vim`) — uses terminal palette indices, not hex
- bat (`bat/config`) — base16 syntax theme
- git-delta (`git/config` [delta] section) — custom background tints

The colorscheme is intentionally terminal-palette-driven: change the terminal theme and neovim updates automatically.

### Zsh Loading Order

Shell initialization follows this sequence:
1. `~/.zshenv` (symlinked from `zsh/zshenv.symlink`) — sets XDG paths, ZDOTDIR, ZCACHEDIR
2. `$ZDOTDIR/.zshrc` (`zsh/.zshrc`) — the main shell config, which runs steps 3-6 in order
3. `~/.zshrc` (local, created by homebrew bootstrap) — `eval "$(brew shellenv)"` which sets `HOMEBREW_PREFIX`, `HOMEBREW_CELLAR`, and adds brew to PATH
4. Starship prompt init, antidote plugins, mise activation
5. `for file in $XDG_CONFIG_HOME/**/*.zsh` sources all config files
6. History, completion, and keybinding setup

The `**/*.zsh` glob auto-discovers config across all directories. Order is filesystem-dependent but safe because all dependencies (homebrew, mise, starship) are initialized before the glob runs in step 5.

### Version Managers

Mise (https://mise.jdx.dev/) manages language runtimes. Global versions are defined in `mise/config.toml`. Mise is activated in `zsh/.zshrc` via `eval "$(mise activate zsh)"` — this runs after homebrew is on PATH but before the `**/*.zsh` glob, so mise-managed tools are available when env.zsh and other config files load.

## Key Files

| File | What it does |
|------|-------------|
| `bootstrap.sh` | Main entry point — OS detection, symlinks, sub-bootstraps |
| `bootstrap.mac.sh` | Homebrew + cask + formula installation |
| `zsh/zshenv.symlink` | First file loaded — XDG paths, ZDOTDIR, ZCACHEDIR |
| `zsh/.zshrc` | Shell init — p10k, antidote, sources all *.zsh files |
| `mise/config.toml` | Global tool versions (node, ruby) for mise |
| `zsh/env.zsh` | EDITOR, PATH additions, GEMRC |
| `zsh/aliases.zsh` | Shell aliases (bat, eza, rg, nvim) |
| `nvim/init.vim` | Neovim config — plugins, settings, mappings |
| `nvim/colors/terminal.vim` | Colorscheme using base24 terminal palette |
| `nvim/plugin/statusline.vim` | Custom statusline with powerline separators |
| `nvim/plugin/tabline.vim` | Custom tabline (buffer list) |
| `ghostty/config` | Ghostty terminal settings |
| `ghostty/themes/base24-twilight` | 24-color palette definition |
| `git/config` | Git config — aliases, delta, Kaleidoscope |

## Editing Guidelines

- **Vimscript, not Lua** — neovim config uses vimscript intentionally. The only Lua is the `vim.pack.add` block and treesitter autocmd in init.vim.
- **Terminal palette colors only** — `nvim/colors/terminal.vim` uses `ctermfg`/`ctermbg` indices (0-23), never hex values. This keeps the colorscheme terminal-theme-agnostic.
- **Bootstrap must be idempotent** — running `bootstrap.sh` twice should produce the same result. Don't overwrite existing files without checking.
- **Don't add features to the colorscheme that require `termguicolors`** — the entire theme system depends on `notermguicolors`.
