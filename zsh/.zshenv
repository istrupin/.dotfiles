# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
. "$HOME/.cargo/env"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export BAT_THEME="rose-pine"

crec() {
	~/code/audioz/record.sh --copy
}

gf() {
  rg --line-number "" "$@" | fzf --delimiter=: --with-nth=1,3.. --preview 'bat --color=always {1}' | cut -d: -f1 | xargs realpath | tr -d '\n' | pbcopy
}


# export NODE_EXTRA_CA_CERTS="$HOME/.claude/corporate-ca-bundle.pem"
export NODE_EXTRA_CA_CERTS="/Library/Application Support/Claude/ca-cert.pem"
# export NODE_EXTRA_CA_CERTS="$HOME/certs/ca-bundle.pem"
# export NODE_EXTRA_CA_CERTS="$HOME/certs/combined-ca-certs.pem"
