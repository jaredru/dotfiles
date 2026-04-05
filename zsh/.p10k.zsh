# Powerlevel10k configuration.
# Based on lean-8colors style with custom git formatting.
# Adapted from starship layout: brackets around dir, dimmed git metrics,
# consistent symbol set.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  # Prompt layout
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    my_dir
    vcs
    newline
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    git_metrics   # async line-level diff stats
    status
    command_execution_time
    background_jobs
    newline
  )

  # General style
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # No connectors between prompt lines
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  typeset -g POWERLEVEL9K_SHOW_RULER=false
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '

  ################################[ prompt_char ]################################
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

  ##################################[ my_dir ]##################################
  # Custom dir segment that bolds the git repo root directory name.
  # Replaces built-in dir (trades smart truncation for repo root bolding).
  function prompt_my_dir() {
    emulate -L zsh
    local dir=${(%):-%~}
    if [[ -n $_git_metrics_toplevel ]]; then
      local name=${_git_metrics_toplevel:t}
      dir=${dir/${name}/%B${name}%b}
    fi
    p10k segment -f 4 -t "%F{20}[%F{4}${dir}%F{20}]"
  }

  #####################################[ vcs ]######################################
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Git status formatter — matches starship symbol set and colors.
  #
  # Symbols: * stashed, + staged, ~ modified, ? untracked, - deleted,
  #          = conflicted, ⇡ ahead, ⇣ behind
  # Colors:  green (clean/ahead/stashed/staged/untracked),
  #          yellow (modified/diverged), red (behind/deleted/conflicted)
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      local       meta='%f'
      local      clean='%2F'   # green
      local   modified='%3F'   # yellow
      local  untracked='%2F'   # green (matching starship)
      local conflicted='%1F'   # red
      local     staged='%2F'   # green
      local    deleted='%1F'   # red
      local    stashed='%2F'   # green
    else
      # Stale/loading state — all default foreground
      local       meta='%f'
      local      clean='%f'
      local   modified='%f'
      local  untracked='%f'
      local conflicted='%f'
      local     staged='%f'
      local    deleted='%f'
      local    stashed='%f'
    fi

    local res
    local where
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}"
      where=${(V)VCS_STATUS_LOCAL_BRANCH}
    elif [[ -n $VCS_STATUS_TAG ]]; then
      res+="${meta}#"
      where=${(V)VCS_STATUS_TAG}
    fi

    (( $#where > 32 )) && where[13,-13]="…"
    res+="${clean}${where//\%/%%}"

    [[ -z $where ]] && res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    # Order matches starship: conflicted, stashed, modified, staged, untracked, ahead/behind
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}=${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_STASHES        )) && res+=" ${stashed}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}~${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${staged}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${deleted}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=2
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3

  ##########################[ status ]###########################
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2

  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=2
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

  typeset -g POWERLEVEL9K_STATUS_ERROR=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1

  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=1
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'

  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'

  ###################[ command_execution_time ]###################
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=

  #######################[ background_jobs ]#######################
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=4

  #################[ git_metrics: async line-level diff stats ]#################
  # Matches starship's git_metrics: +added -deleted in dimmed green/red.
  # Runs git diff --shortstat asynchronously via zsh-async so it never blocks
  # the prompt. Shows cached results immediately, updates when async completes.

  typeset -g _git_metrics_initialized=0
  typeset -gA _git_metrics_cache=()
  typeset -g _git_metrics_display=""
  typeset -g _git_metrics_toplevel=""

  function _git_metrics_async() {
    local dir=$1
    local toplevel
    toplevel=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || return 1
    local stats
    stats=$(git -C "$toplevel" diff --shortstat HEAD 2>/dev/null)
    local added=0 deleted=0
    if [[ -n $stats ]]; then
      [[ $stats =~ '([0-9]+) insertion' ]] && added=$match[1]
      [[ $stats =~ '([0-9]+) deletion' ]] && deleted=$match[1]
    fi
    echo "${toplevel}"$'\n'"${added}"$'\n'"${deleted}"
  }

  function _git_metrics_callback() {
    local job=$1 exit_code=$2 output=$3
    if [[ $exit_code == 0 && -n $output ]]; then
      local lines=(${(f)output})
      local toplevel=$lines[1] added=$lines[2] deleted=$lines[3]
      local dim=$'\e[2m' nodim=$'\e[22m'
      local display=""
      (( added > 0 )) && display="%{${dim}%}%F{2}+${added}%f%{${nodim}%}"
      (( deleted > 0 )) && display+="${display:+ }%{${dim}%}%F{1}-${deleted}%f%{${nodim}%}"
      _git_metrics_cache[$toplevel]=$display
      # Update display directly if result is for the current repo
      [[ $toplevel == $_git_metrics_toplevel ]] && _git_metrics_display=$display
    fi
    p10k display -r
  }

  function prompt_git_metrics() {
    # Lazy-init: zsh-async loads after this file is sourced
    if (( ! _git_metrics_initialized )) && (( $+functions[async_init] )); then
      async_init
      async_stop_worker _git_metrics_worker 2>/dev/null
      async_start_worker _git_metrics_worker
      async_register_callback _git_metrics_worker _git_metrics_callback
      _git_metrics_initialized=1
    fi
    (( _git_metrics_initialized )) || return

    local toplevel
    toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || return

    # Track current repo so callback knows if its result is still relevant
    if [[ $toplevel != $_git_metrics_toplevel ]]; then
      _git_metrics_display=${_git_metrics_cache[$toplevel]:-}
      _git_metrics_toplevel=$toplevel
    fi

    async_job _git_metrics_worker _git_metrics_async "$PWD"
    p10k segment -c '$_git_metrics_display' -t '$_git_metrics_display' -e
  }

  # Instant prompt — display prompt immediately while plugins load.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
}

# Restore options that were disabled at the top of this file.
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
