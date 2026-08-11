export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

export PATH="$PATH:$(go env GOPATH)/bin"
