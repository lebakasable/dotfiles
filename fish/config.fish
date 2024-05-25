set fish_greeting

bind \cz fg

fish_add_path ~/odin
fish_add_path ~/roc
fish_add_path ~/go/bin
fish_add_path ~/.nimble/bin
fish_add_path /opt/Min

alias nv nvim
alias k kak
alias ls exa
alias ll "exa -l --icons"
alias la "exa -a"
alias lla "exa -la --icons"

zoxide init fish | source

alias cd z
alias v vim

set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin ~/.ghcup/bin $PATH

source ~/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

set -gx NNN_FCOLORS 0B0B04060006060009060B06

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
