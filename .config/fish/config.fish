set fish_greeting

set -gx EDITOR kak
set -gx VISUAL kak
set -gx NEWT_COLORS "root=black,black;window=black,black;border=white,black;listbox=white,black;label=blue,black;checkbox=red,black;title=green,black;button=white,red;actsellistbox=black,red;actlistbox=white,gray;compactbutton=white,gray;actcheckbox=white,blue;entry=lightgray,black;textbox=blue,black"
set -gx FZF_DEFAULT_OPTS "--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#45475a --multi"
set -gx NNN_COLORS "#04020301;4231"
set -gx NNN_FCOLORS "030304020705050801060301"

set -gx PNPM_HOME "/home/hugo/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
   set -gx PATH "$PNPM_HOME" $PATH
end

fish_add_path ~/.cargo/bin
fish_add_path ~/.local/share/gem/ruby/3.3.0/bin
fish_add_path ~/projects/oak/bin

alias v vim
alias k "kak -c meow"
alias cd z
alias nnn "nnn -e"
alias config "git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

nvm use latest --silent

function starship_transient_prompt_func
   starship module character
end
starship init fish | source
enable_transience

zoxide init fish | source
