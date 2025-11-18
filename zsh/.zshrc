# zmodload zsh/zprof

# eval "$(pyenv init -)" ## comment out because going to try to use mise
eval "$(mise activate zsh)"
# Removed: eval $(ssh-agent) - using macOS Keychain integration instead

# NVM lazy loading moved to zinit section below


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/igorstrupinskiy/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
#
#
export EDITOR='nvim'

# Added by Windsurf
export PATH="/Users/igorstrupinskiy/.codeium/windsurf/bin:$PATH"

export EZA_CONFIG_DIR="$HOME/.config/eza/"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Old simple compinit (slow on every shell startup):
# autoload -U compinit && compinit

# Cache compinit for faster startup - only rebuild once per 24 hours
# Must run BEFORE fzf-tab (per fzf-tab docs)
autoload -Uz compinit

if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qNmh+24) ]]; then
  compinit  # Rebuild cache if older than 24 hours
else
  compinit -C  # Skip security check and use cached version
fi

# SDKMAN initialization (kept after compinit to avoid duplicate compinit calls)
# commented out bc trying Mise
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Initialize completions

zinit light zsh-users/zsh-completions  # Use 'light' to prevent duplicate compinit calls
zinit load zsh-users/zsh-syntax-highlighting

# Initialize fzf after zsh-vi-mode completes to prevent keybinding conflicts
# if you get rid of the zvm_after_init you still need to  source <(fzf --zsh)
function zvm_after_init() {
  source <(fzf --zsh)
}

zinit load jeffreytse/zsh-vi-mode

zinit load zsh-users/zsh-autosuggestions

# fzf-tab - replaces tab completion with fzf interface
zinit load Aloxaf/fzf-tab


# old fzf sourcing happened here
### End of Zinit's installer chunk
#
#
# 
#
#

alias gst='git status'
alias ga='git add'
alias gc='git commit -v'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'

alias e='eza'
alias ee='eza -la'
alias ll='eza -la'
alias la='ls -lAh' 
alias l='ls -lah'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

eval "$(zoxide init zsh)"

# History optimization for starship compatibility
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_FIND_NO_DUPS
HISTSIZE=5000
SAVEHIST=5000

# Force immediate history loading before starship init
fc -R

eval "$(starship init zsh)"

# zprof
