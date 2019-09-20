achuie='[%(!.%F{red}.%F{blue})%n@%m%f %1~${vcs_info_msg_0_}]%# '

function prompt_achuie_precmd() {
    vcs_info
    PS1=$achuie
}

function prompt_achuie_setup() {
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git

    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' unstagedstr '!'
    zstyle ':vcs_info:*' stagedstr '*'
    zstyle ':vcs_info:*' actionformats '%F{green}(%b|%a)%c%u%f'
    zstyle '"vcs_info:*' formats '%F{green}(%b)%c%u%f'

    vcs_info
    precmd_functions+=(prompt_achuie_precmd)
    PS1=$achuie
}

prompt_achuie_setup "$@"
