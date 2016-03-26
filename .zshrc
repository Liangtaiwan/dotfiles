#############################
# Load plugins
#############################
# enable fuzzy finder if it exists
if [[ -f "~/.fzf.zsh" ]] ; then
  source "~/.fzf.zsh"
  export FZF_DEFAULT_OPTS="-m --cycle"
  (( $+commands[ag] )) && export FZF_DEFAULT_COMMAND='ag -l -g ""'
fi

if ! [[ -f "${HOME}/.zplug/zplug" ]]; then
  echo "Downloading zplug..."
  curl --progress-bar -fLo "${HOME}/.zplug/zplug" --create-dirs https://git.io/zplug
fi
source "${HOME}/.zplug/zplug"

zplug "mafredri/zsh-async", of:"*.plugin.zsh", nice:-20
zplug "leomao/zsh-hooks", of:"*.plugin.zsh", nice:-20
zplug "zsh-users/zsh-completions", of:"*.plugin.zsh", nice:-20
zplug "leomao/vim.zsh", of:vim.zsh, nice:-5
zplug "leomao/pika-prompt", of:pika-prompt.zsh
zplug "rupa/z", of:z.sh
zplug "so-fancy/diff-so-fancy", as:command
zplug "knu/zsh-manydots-magic", of:manydots-magic, nice:16

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
zplug "zsh-users/zsh-syntax-highlighting", of:"*.plugin.zsh", nice:15

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

#############################
# Path
#############################
# Because of a bug, we set path here instead of .zshenv
# see the notes below
# https://wiki.archlinux.org/index.php/Zsh#Configuration_files
if (( $+commands[ruby] )) ; then
  if [[ -d ~/.rbenv ]] ; then
    # use rbenv if it exists
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
  else
    # According to https://wiki.archlinux.org/index.php/Ruby#RubyGems
    export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
    export PATH="${GEM_HOME}/bin:$PATH"
  fi
fi

if (( $+commands[npm] )) ; then
  export PATH="$HOME/.node_modules/bin:$PATH"
  export npm_config_prefix=~/.node_modules
fi

#############################
# Options
#############################
# don't record duplicate history
setopt hist_ignore_dups

# no flow control
setopt noflowcontrol

# rm confirmation
setopt rm_star_wait

# Directory Stack settings
DIRSTACKSIZE=8
setopt auto_cd
setopt autopushd pushdminus pushdsilent pushdtohome

#############################
# Aliases
#############################
# List direcory contents
alias ls='ls -h --color --group-directories-first'
alias l='ls -F'
alias ll='ls -lF'
alias la='ls -lAF'
alias lx='ls -lXB'
alias lk='ls -lSr'
alias lt='ls -lAFtr'
alias sl=ls # often screw this up

# Show history
alias history='fc -l 1'

# Tmux 256 default
alias tmux='tmux -2'

# vi as vim
alias vi='vim'
if (( $+commands[nvim] )) ; then
  alias vi='nvim'
fi

# Directory Stack alias
alias dirs='dirs -v'
alias ds='dirs'

alias zc='z -c'

#############################
# Completions
#############################
# Important
zstyle ':completion:*:default' menu yes=long select=2

# Completing Groping
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{226}Completing %F{214}%d%f'
zstyle ':completion:*' group-name ''

# Completing misc
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd
export LS_COLORS='di=01;94:ln=01;96:ex=01;92'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# default: --
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# load custom settings
if [[ -f "~/.zshrc.local" ]]; then
  source "~/.zshrc.local"
fi
