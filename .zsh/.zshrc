## Set window title
function win_title() { print -Pn "\e]2;%n@%m:%~\a" }
precmd_functions+=(win_title)

## Shell Options
setopt appendhistory
setopt extendedglob
setopt nomatch
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt prompt_subst

unsetopt autocd
unsetopt beep
unsetopt notify

## Path
typeset -U PATH path FPATH fpath
path=("$HOME/scripts" "$path[@]")
export PATH

fpath=("$ZDOTDIR/functions" "$fpath[@]")
export FPATH

## Prompt
autoload -Uz promptinit
promptinit
prompt achuie

## Aliases
alias ls='ls --color=auto -N'
alias git-log='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %Cgreen(%cr) %C(bold blue)<%an>%Creset %<(50,trunc)%s'\'' --all'
alias git-vlog='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %Cgreen%aD%Creset%n''          %C(bold blue)<%an>%Creset %<(80,trunc)%s'\'' --all'

## History
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=${HISTSIZE}
export HISTSIZE SAVEHIST HISTFILE

## Editor
export EDITOR="vim"
export VISUAL="$EDITOR"
bindkey -v

## Completion
autoload -Uz compinit
compinit

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' prompt 'errors: %e'
zstyle ':completion:*' menu select
zstyle :compinstall filename '/home/achuie/.zshrc'

## Keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^R" history-incremental-pattern-search-backward

# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start {
        echoti smkx
    }
    function zle_application_mode_stop {
        echoti rmkx
    }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# Setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-beginning-search
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-beginning-search
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

## ranger-cd
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
