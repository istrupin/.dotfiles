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
| lazygit       | git TUI (themes only)| `lazygit/`   |
| ssh           | shared ssh config    | `ssh/`       |
| mise          | runtime version mgr  | (not stowed) |

## Install on a fresh Mac

```bash
# Core shell / editor / terminal workflow
brew install stow zsh neovim tmux yazi lazygit starship zoxide fzf eza bat ripgrep fd mise git git-delta stylua tree-sitter-cli

# Terminal + nerd fonts
brew install --cask ghostty font-meslo-lg-nerd-font font-symbols-only-nerd-font

# Clone
git clone git@github.com:<you>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Stow everything that deploys into $HOME
stow zsh nvim tmux ghostty starship yazi ssh
# Note: `lazygit/` only holds theme files — not stowed, referenced manually.

# tmux plugin manager (needed before first tmux launch)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then inside tmux: prefix + I to install plugins.

# zinit + lazy.nvim + starship all self-bootstrap on first run.
```

## Machine-local overrides

Anything host-specific goes in files that are **not** in this repo:

- `~/.ssh/config.local` — per-host SSH entries (included from `ssh/.ssh/config`)
- `~/.zshrc.local` — sourced at the end of `.zshrc` if present (add the source line when you need it; not wired by default)

## Gitignored

- `nvim/.config/nvim/lua/istrupinskiy/llm_env.lua` — API keys for the companion plugin

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
