function prompt_achuie_precmd() {
    export PS1=$'[\e[0;34m%n@%m\e[m %1~]%# '
}

function prompt_achuie_setup() {
    PS1=$'[\e[0;34m%n@%m\e[m %1~]%# '

    precmd_functions+=(prompt_achuie_precmd)
}

prompt_achuie_setup "$@"
