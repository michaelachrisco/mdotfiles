# zsh config
# Mark Hegreberg
# written 2021-05030

# colors and prompts
autoload -U colors && colors
autoload -Uz promptinit
promptinit
export LC_ALL="en_US.UTF-8"
alias ls='ls --color=auto'
RPROMPT='%3~'

export PATH=~/scripts:$PATH
export PATH=~/.dotnet/tools:$PATH

export KUBE_EDITOR=nvim

# dotnet 

# opt out of telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1
# make entity framework calm down
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
export DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY=0:
export CLR_ICU_VERSION_OVERRIDE="71.1"
# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

# ruby
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# aliases
alias ':q'=exit
alias ':wq'=exit
alias 'ZZ'=exit

alias v=nvim
alias vim=nvim
alias n=nvim
alias nv=nvim

alias g=git
alias G=git
alias gf='git fugitive'
alias gs='git status'

alias t=tmux
alias tend='tmux kill-session && tmux attach'

alias dn=dotnet
alias dnb='dotnet build'
alias dr='dotnet run'
alias dnef='dotnet ef'
alias fastef='dotnet ef --no-build'
alias dnup='dotnet list package --outdated'
alias dnap='dotnet add package'

alias mkcd='. mkcd'
alias fcd='. fuzzycd'
alias work=tmux-session-template
alias psrun='Powershell.exe  -File'

# completion settings
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '/home/mark/.zshrc'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# get zsh complete kubectl
source <(kubectl completion zsh)
# make completion work with kubecolor
compdef kubecolor=kubectl

# Vim mode
bindkey -v
export KEYTIMEOUT=1

# Vim nav in menus
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

source ~/.zshrc.local
source ~/.local/share/zsh/highlighting/zsh-syntax-highlighting.zsh
