# Igor's Dotfiles

Personal macOS config, managed with GNU stow.

## Stack

| Tool          | Role                 | Package dir  |
| ------------- | -------------------- | ------------ |
| zsh + zinit   | shell + plugins      | `zsh/`       |
| starship      | prompt               | `starship/`  |
| ghostty       | terminal             | `ghostty/`   |
| tmux + tpm    | multiplexer          | `tmux/`      |
| neovim + lazy | editor               | `nvim/`      |
| yazi          | file manager         | `yazi/`      |
| git + delta   | diff pager, merge conflict style | `git/` |
| bat           | syntax highlighter (rose-pine theme) | `bat/` |
| lazygit       | git TUI (themes + delta pager cfg) | `lazygit/` |
| k9s           | kubernetes TUI (rose-pine skin) | `k9s/`  |
| ssh           | shared ssh config    | `ssh/`       |
| mise          | runtime version mgr  | (not stowed) |

## Install on a fresh Mac

```bash
# Core shell / editor / terminal workflow
brew install stow zsh neovim tmux yazi lazygit k9s starship zoxide fzf eza bat ripgrep fd mise git git-delta stylua tree-sitter-cli

# Terminal + nerd fonts
brew install --cask ghostty font-meslo-lg-nerd-font font-symbols-only-nerd-font

# Clone
git clone git@github.com:<you>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# ~/.ssh must be a real directory *before* stowing, otherwise stow
# "folds" it into a symlink at ~/.ssh -> ~/.dotfiles/ssh/.ssh and
# every key / known_hosts / config.local you create lands in the repo.
mkdir -p ~/.ssh && chmod 700 ~/.ssh

# Same folding trap for k9s (it would write logs + cluster state into
# the repo). Also needs K9S_CONFIG_DIR set — see the k9s note below.
mkdir -p ~/.config/k9s/skins

# Stow everything that deploys into $HOME
stow zsh nvim tmux ghostty starship yazi ssh git bat k9s
# bat custom themes only appear after rebuilding its cache:
bat cache --build
# Note: `lazygit/` holds theme files + config.yml — not stowed (lazygit's
# config dir is outside $HOME's XDG path on macOS), symlink it manually:
mkdir -p "$HOME/Library/Application Support/lazygit"
ln -sf ~/.dotfiles/lazygit/config.yml "$HOME/Library/Application Support/lazygit/config.yml"

# yazi flavors (color schemes) are pinned in yazi/.config/yazi/package.toml
# but not committed — fetch them into ~/.config/yazi/flavors:
ya pkg install

# tmux plugin manager (needed before first tmux launch)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then inside tmux: prefix + I to install plugins.

# zinit + lazy.nvim + starship all self-bootstrap on first run.
```

## Machine-local overrides

Anything host-specific goes in files that are **not** in this repo:

- `~/.ssh/config.local` — per-host SSH entries (included from `ssh/.ssh/config`)
- SSH keys, `known_hosts`, and the agent socket — live in the real `~/.ssh` directory. The only tracked file is `ssh/.ssh/config`.
- `~/.zshrc.local` — sourced at the end of `.zshrc` if present (add the source line when you need it; not wired by default)
- `~/.config/mise/config.toml` — mise `[env]` block; holds API keys, AWS profiles, and `K9S_CONFIG_DIR` (see the k9s note below)

## Gitignored

- `nvim/.config/nvim/lua/istrupinskiy/llm_env.lua` — API keys for the companion plugin
- `yazi/.config/yazi/flavors/` — yazi color schemes, restored via `ya pkg install` (pin lives in `package.toml`)
- `ssh/.ssh/id_*`, `*.pub`, `config.local`, `known_hosts*`, `agent/` — safety net if stow folds `~/.ssh` into the package
- `k9s/.config/k9s/k9s.log`, `clusters/`, `benchmarks/`, `screen-dumps/` — same safety net if stow folds `~/.config/k9s`

## SSH key management

With `UseKeychain yes`, new SSH keys are added to the macOS Keychain automatically on first use. Manual commands for reference:

```bash
# Add key to Keychain explicitly
ssh-add --apple-use-keychain ~/.ssh/<key>

# List keys in the agent
ssh-add -l

# Remove from current agent session
ssh-add -d ~/.ssh/<key>

# Remove all keys from current session
ssh-add -D

# Remove from Keychain permanently
ssh-add -K -d ~/.ssh/<key>
# or: Keychain Access app → search for the key → delete
```

`ssh-add -d` only affects the current session. Use `-K -d` or Keychain Access for permanent removal.

### What the SSH config does

- `AddKeysToAgent yes` — auto-add keys to ssh-agent
- `UseKeychain yes` — persist keys in macOS Keychain
- `IgnoreUnknown UseKeychain` — keeps Homebrew's OpenSSH from choking on the above
- `IdentitiesOnly yes` — only offer explicitly-configured keys
- `Include ~/.ssh/config.local` — per-host overrides (loaded first, so they take precedence)

### What the git + delta config does

`git/.gitconfig` (stowed to `~/.gitconfig`):

- `core.pager = delta` — routes `git diff`/`show`/`log -p` through delta
- `interactive.diffFilter = delta --color-only` — delta rendering for `git add -p`
- `delta.dark = true` — hardcoded rather than auto-detected (see lazygit note below)
- `delta.navigate = true` / `delta.line-numbers = true`
- `merge.conflictstyle = zdiff3` — cleaner conflict markers, renders well through delta

`lazygit/config.yml` (symlinked manually to `~/Library/Application Support/lazygit/config.yml` — lazygit's config dir on macOS isn't under `~/.config`, so `stow` can't place it there directly):

```yaml
git:
  diffRenderers:
    - colorArg: always
      command: delta --dark --paging=never
```

- `--paging=never` — required; delta shelling out to `less` internally breaks lazygit's own scroll handling
- `--dark` — explicit rather than relying on delta's auto light/dark detection, which is [known to fail inside lazygit's PTY](https://github.com/dandavison/delta/issues/1968)
- If lazygit has never been launched on a fresh machine, it creates an empty `config.yml` on first run — delete that before symlinking, or the `ln -sf` (which does overwrite) handles it anyway since `-f` forces the replace

**Theme:** `config.yml` also has the rose-pine `gui.theme` colors pasted directly into it (copied from `lazygit/themes/rose-pine.yml`). Lazygit has no include/import directive inside a config file, so this is the simplest way to get a theme applied. Downside: the colors are now duplicated — if upstream `rose-pine/lazygit` changes its theme file, `themes/rose-pine.yml` won't auto-update what's actually loaded.

Alternative we didn't take: lazygit supports merging multiple config files at launch via `LG_CONFIG_FILE` (or `--use-config-file`), comma-separated:

```bash
export LG_CONFIG_FILE="$HOME/.dotfiles/lazygit/config.yml,$HOME/.dotfiles/lazygit/themes/rose-pine.yml"
```

This would keep `themes/rose-pine.yml` untouched and swappable (e.g. point at `rose-pine-dawn.yml` instead for a light variant) instead of baking colors into `config.yml`. Not currently wired up — would need adding to the `zsh/` env.

### What the k9s config does

k9s on macOS defaults to `~/Library/Application Support/k9s` — the same out-of-XDG problem lazygit has, except k9s honors `K9S_CONFIG_DIR`, so pointing that at `~/.config/k9s` makes it an ordinary stow package instead of a manual symlink. The var is set in `~/.config/mise/config.toml` (untracked); without it k9s ignores this package entirely. `k9s info` prints the paths actually in use.

`skins/rose-pine.yaml` is copied verbatim from [`derailed/k9s`](https://github.com/derailed/k9s/tree/master/skins); `config.yaml` just names it. k9s rewrites `config.yaml` on exit and that write follows the symlink into the repo, so expect occasional `git status` churn.

`zsh/.zshenv` sets `BAT_THEME=rose-pine`. That is **not** a built-in bat theme — the `.tmTheme` lives in `bat/.config/bat/themes/` (stowed to `~/.config/bat/themes/`). Lazygit shells out to `bat` for syntax highlighting (untracked files, some previews), so if the theme isn't installed — or `bat cache --build` hasn't been run after installing it — the unstaged-changes pane shows `[bat warning]: Unknown theme 'rose-pine'`.
