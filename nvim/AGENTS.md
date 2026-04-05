# Neovim Configuration

- **Stack:** Neovim / Vimscript (not Lua) / vim.pack / Treesitter
- **Theme:** `colors/terminal.vim` — base24 terminal palette, no hex colors
- **Plugins:** vim.pack (built-in, installs to `~/.local/share/nvim/site/pack/core/opt/`)

## What This Component Does

Neovim editor configuration with a custom colorscheme that uses the terminal's color palette directly (ANSI 0-15 + base24 extended 16-23). Includes a hand-built statusline and tabline with powerline separators, treesitter syntax highlighting, and a curated set of plugins.

## Key Files

| File | Purpose |
|------|---------|
| `init.vim` | Main config: XDG paths, plugins, settings, mappings, autocommands |
| `colors/terminal.vim` | Colorscheme: syntax, editor UI, statusline, tabline highlight groups |
| `plugin/statusline.vim` | Statusline: mode indicator, git branch, file, position (powerline style) |
| `plugin/tabline.vim` | Tabline: buffer list with powerline separators between active/inactive |
| `nvim-pack-lock.json` | Plugin version lock file (managed by vim.pack) |
| `bootstrap.sh` | Runs `nvim +qall` to trigger plugin installation |

## Architecture

### Colorscheme Design

`terminal.vim` uses only `ctermfg`/`ctermbg` with palette indices — never hex values, never `guifg`/`guibg`. The `notermguicolors` setting is mandatory. This means:
- Palette 0-7: standard ANSI colors (mapped from base16-twilight accents)
- Palette 8: bright black (comments)
- Palette 9-14: ANSI bright variants (lighter versions of 1-6)
- Palette 15: bright white
- Palette 16-21: base16 intermediate shades (orange, brown, dark bg, selection, dark fg, light fg)
- Palette 22-23: base24 darker backgrounds

The actual hex values live in the terminal theme (`ghostty/themes/base24-twilight`). Change the terminal theme and neovim updates automatically.

### Statusline / Tabline

Defined in `plugin/` files (auto-sourced by neovim), with highlight groups in `colors/terminal.vim`. The statusline uses `%{%BuildStatusLine()%}` for mode-aware dynamic highlighting. Powerline glyphs: `\ue0b0` (right triangle), `\ue0b1` (thin right), `\ue0b2` (left triangle). Font must include powerline symbols (Consolas NF).

### Plugin Management

`vim.pack.add()` in the Lua block of init.vim. Plugins install to `~/.local/share/nvim/site/pack/core/opt/`. Lock file at `nvim-pack-lock.json`. Update with `:Pack update`.

## Editing Guidelines

- **Vimscript only** — the only Lua is the vim.pack block and treesitter autocmd. Don't convert to Lua.
- **No hex colors in terminal.vim** — use palette indices only. If you need a new shade, add it to the ghostty theme first, then reference the palette index.
- **No `termguicolors`** — this breaks the entire palette-index approach.
- **Test with multiple buffers** — the tabline renders differently with 1 buffer vs many. Check separator colors at all transitions (fill→sel, sel→tab, tab→tab).
- **Leader is `,`** — not backslash.
- **`set autochdir`** is on — neovim's cwd changes to the directory of the current file. Plugins that depend on cwd (like signify) run from the file's directory, not the repo root.
