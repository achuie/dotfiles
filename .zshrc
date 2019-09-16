# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' prompt 'errors: %e'
zstyle :compinstall filename '/home/achuie/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch hist_ignore_all_dups hist_ignore_space
unsetopt autocd beep notify
bindkey -v
# End of lines configured by zsh-newuser-install
prompt default
