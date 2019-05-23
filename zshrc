#############################
# Load zle
#############################
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#############################
# Load plugins
#############################
if [[ -f /etc/arch-release ]]; then
  package_list=(fzf diff-so-fancy zsh-syntax-highlighting zsh-completions)
  if ! pacman -Qq ${package_list[@]} > /dev/null 2>&1; then
    echo "You're using Archlinux! Use pacman to manage some nice tools:"
    echo ${package_list[@]}
  fi
fi

if [[ -x /usr/bin/fzf && -f /usr/share/fzf/key-bindings.zsh &&
    -f /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
else
  if ! [[ -f ~/.fzf.zsh ]] ; then
    if ! [[ -f ~/.fzf/install ]] ; then
      rm -rf ~/.fzf
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    ~/.fzf/install --all
  fi
  source ~/.fzf.zsh
fi

export FZF_DEFAULT_OPTS="-m --cycle"
if (( $+commands[rg] )) ; then
  export FZF_DEFAULT_COMMAND='rg -l ""'
elif (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag -l -g ""'
fi

if ! [[ -f "${HOME}/.zplug/init.zsh" ]]; then
  curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi
zstyle :zplug:tag depth 1
source "${HOME}/.zplug/init.zsh"

zplug "zplug/zplug"
zplug "mafredri/zsh-async", use:async.zsh
zplug "leomao/vim.zsh", use:vim.zsh, defer:1
export PURE_GIT_PULL=0
zplug "liangtaiwan/pure", use:pure.zsh, defer:2
export ENHANCD_DISABLE_HOME=1
export ENHANCD_DOT_ARG='.'
zplug "b4b4r07/enhancd", use:init.sh

if [[ -f /etc/arch-release ]]; then
  if [[ -d /usr/share/zsh/plugins/zsh-syntax-highlighting ]]; then
    zplug "/usr/share/zsh/plugins/zsh-syntax-highlighting", from:local, defer:3
  fi
else
  zplug "zsh-users/zsh-completions", use:"*.plugin.zsh"
  zplug "so-fancy/diff-so-fancy", as:command, use:diff-so-fancy
  zplug "zsh-users/zsh-syntax-highlighting", use:"*.plugin.zsh", defer:3
fi

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

if ! zplug check --verbose; then
  zplug install
fi

zplug load

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
setopt autopushd pushdminus pushdsilent pushdtohome pushd_ignore_dups

setopt mark_dirs
setopt multios

# also do completion for aliases
setopt complete_aliases

#############################
# Aliases
#############################
# List direcory contents
if (( $+commands[exa] )) ; then
  alias ls='exa --group-directories-first'
  alias l='ls -F'
  alias ll='ls -glF'
  alias la='ll -a'
  alias lx='ll -s extension'
  alias lk='ll -rs size'
  alias lt='ll -ars modified'
else
  alias ls='ls -h --color --group-directories-first'
  alias l='ls -F'
  alias ll='ls -lF'
  alias la='ls -lAF'
  alias lx='ls -lXB'
  alias lk='ls -lSr'
  alias lt='ls -lAFtr'
fi
alias sl=ls # often screw this up

# grep
if (( $+commands[rg] )); then
  alias gg='rg'
elif (( $+commands[ag] )); then
  alias gg='ag'
else
  alias gg='grep -R -n'
fi

# Show history
alias history='fc -l 1'

# Tmux 256 default
alias tmux='tmux -2'

# vim alias
if [[ `vim --version 2> /dev/null | grep -- +clientserver` ]] ; then
  # always use vim client server
  alias vim='vim --servername vim'
fi
alias vi='vim'
alias v='vim'
if (( $+commands[nvim] )) ; then
  alias v='nvim'
fi

# tmux alias
if (( $+commands[tmux] )) ; then
  alias tma="tmux at"
  alias tmat="tmux at -t"
  alias tnew="tmux new -s"
fi
# Directory Stack alias
alias dirs='dirs -v'
alias ds='dirs'

# use thefuck if available
if (( $+commands[thefuck] )) ; then
  eval $(thefuck --alias)
fi


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
export LS_COLORS='di=1;34:ln=36:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# default: --
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

############################
# History Configuration
############################
## History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
#############################



## Bing Key
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e                                            # Use emacs key bindings

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
if [[ "${terminfo[kpp]}" != "" ]]; then
  bindkey "${terminfo[kpp]}" up-line-or-history       # [PageUp] - Up a line of history
fi
if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey "${terminfo[knp]}" down-line-or-history     # [PageDown] - Down a line of history
fi

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

bindkey ' ' magic-space                               # [Space] - do history expansion

bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word



# load custom settings
if [[ -f "${HOME}/.zshrc.local" ]]; then
  source "${HOME}/.zshrc.local"
fi
