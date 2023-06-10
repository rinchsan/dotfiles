set -gx PATH $PATH $HOME/dotfiles/bin
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin
set -gx PATH $PATH /flutter/bin
set -gx PATH $PATH $HOME/google-cloud-sdk/bin
set -gx PATH $PATH /opt/homebrew/bin
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx FZF_DEFAULT_COMMAND 'rg --files --follow --no-ignore-vcs --hidden -g \'!{**/node_modules/*,**/.git/*}\''
set -gx FZF_DEFAULT_OPTS '--height 50% --reverse --border'

