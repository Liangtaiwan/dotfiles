# Powerlevel10k config — Pure style.
# Mirrors the look of refrainblue/pure that we used to load via zplug.
# Regenerate with `p10k configure` and pick the Pure preset for a fresh baseline.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.7.1 -o is-at-least 5.8 && \
    typeset -g POWERLEVEL9K_LEGACY_ICON_SPACING=true

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context                 # user@host
    dir                     # current directory
    vcs                     # git status
    prompt_char             # prompt symbol
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    virtualenv              # python virtual environment
    anaconda                # conda environment
    pyenv                   # python environment (pyenv)
    nodenv                  # node.js version (nodenv)
    nvm                     # node.js version from nvm
    nodeenv                 # node.js environment (nodeenv)
    rbenv                   # ruby version from rbenv
    rvm                     # ruby version from rvm
    kubecontext             # kubernetes context
    terraform               # terraform workspace
    aws                     # aws profile
    gcloud                  # google cloud cli
    context                 # user@host
    time                    # current time
  )

  typeset -g POWERLEVEL9K_MODE=ascii
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=

  # Directory: blue, full path, last component bold.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=blue
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

  # Prompt char: magenta '❯' (red on error).
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=magenta
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=red
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # VCS (git): branch, dirty marker, ahead/behind. Pure-ish look.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=?
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=242
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=242
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=242
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=242

  function my_git_formatter() {
    emulate -L zsh
    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi
    local res
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 32 )) && branch[13,-13]="…"
      res+="%242F${branch//\%/%%}"
    elif [[ -n $VCS_STATUS_TAG ]]; then
      res+="%242F#${VCS_STATUS_TAG//\%/%%}"
    else
      res+="%242F@${VCS_STATUS_COMMIT[1,8]}"
    fi
    # Dirty: red asterisk after branch name.
    if (( VCS_STATUS_HAS_STAGED || VCS_STATUS_HAS_UNSTAGED ||
          VCS_STATUS_HAS_UNTRACKED )); then
      res+=' %1F*'
    fi
    # Ahead/behind: cyan.
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+=" %6F⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" %6F⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_STASHES        )) && res+=" %242F*${VCS_STATUS_STASHES}"
    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  # Pure never auto-fetches; match that behavior.
  typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash)

  # Execution time: yellow, shown when >5s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT=d_h_m_s

  # Right-prompt segments — quiet unless active.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='✦'
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=242
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=242
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=242
  typeset -g POWERLEVEL9K_NODENV_FOREGROUND=242
  typeset -g POWERLEVEL9K_NVM_FOREGROUND=242
  typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=242
  typeset -g POWERLEVEL9K_RBENV_FOREGROUND=242
  typeset -g POWERLEVEL9K_RVM_FOREGROUND=242
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=242
  typeset -g POWERLEVEL9K_TERRAFORM_FOREGROUND=242
  typeset -g POWERLEVEL9K_AWS_FOREGROUND=242
  typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=242

  # Context (user@host) — only show when remote / root.
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=242
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=red
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_USER=

  # Time (only on demand).
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=242
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # Transient prompt collapses old prompts to a single line — feels like pure.
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
