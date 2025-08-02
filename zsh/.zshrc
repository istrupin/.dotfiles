eval "$(pyenv init -)"
eval $(ssh-agent)

source $(brew --prefix nvm)/nvm.sh
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && \. "/usr/local/opt/nvm/etc/bash_completion"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/igorstrupinskiy/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
#
#
export EDITOR='nvim'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Added by Windsurf
export PATH="/Users/igorstrupinskiy/.codeium/windsurf/bin:$PATH"





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


# Initialize completions

zinit load zsh-users/zsh-completions
zinit load zsh-users/zsh-syntax-highlighting  

zinit ice wait lucid
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid
# fzf-tab - replaces tab completion with fzf interface
zinit load Aloxaf/fzf-tab




source <(fzf --zsh)

autoload -U compinit && compinit

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
# alias ll='ls -la'

alias ll='ls -la'
alias la='ls -lAh' 
alias l='ls -lah'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'


eval "$(starship init zsh)"
