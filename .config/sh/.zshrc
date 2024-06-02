export delim=' • '

# Prompt
case $wm {
	#xfwm4)
	#	PS1='$($bin/own/asdfgh -w $PWD 2>/dev/null) %% '
	#	RPS1='%(?..%F{red}%?%f)'
	#;;

	*) PS1=$'%{%(?..%F{red})\e[7m%} %~ %{\e[m%}%f ' ;;
}
#_() { shuf -n 1 /usr/share/dict/words | sed -e "s/'//g" -e "s/.*/\l&/"; }; PS1='%F{magenta}$(_)%f@%F{magenta}$(_)%f%# '

# Title
case $OSTYPE {
	linux*) read -r pp < /proc/$PPID/comm ;;
	*) pp=$(ps -o comm $PPID) ;;
}

chpwd() printf '\e]2;%s%s%s\a' $pp $delim ${(%):-%~}

chpwd

# History
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=99999
SAVEHIST=$HISTSIZE
alias history='builtin fc -li 1'

(( $+SSH_CLIENT )) && return

# Key bindings
bindwidget() {
	local widget=${1%%\(*}

	[[ $1 == *'()'* ]] && eval $1
	(( ! $+widgets[$widget] )) && autoload -U $widget
	zle -N $widget
	(( $+2 )) && bindkey $2 $widget
}

## Make sure that the terminal is in
## ..application mode when zle is active,
## since only then values from $terminfo are correct.
if (( $+terminfo[smkx] && $+terminfo[rmkx] )) {
	bindwidget 'zle-line-init() echoti smkx'
	bindwidget 'zle-line-finish() echoti rmkx'
}

bindkey -e
bindkey '^[[1;5D' vi-backward-word
bindkey '^[[1;6D' backward-word
bindkey '^[[1;5C' vi-forward-word
bindkey '^[[1;6C' forward-word
bindkey $terminfo[kbs] backward-delete-char
bindkey $terminfo[kdch1] delete-char
bindkey '^H' vi-backward-kill-word
bindkey '5~' kill-word
bindwidget up-line-or-beginning-search $terminfo[kcuu1]
bindwidget down-line-or-beginning-search $terminfo[kcud1]
bindwidget edit-command-line '\C-x'
bindwidget 'exit-zsh() exit' '^D'
bindwidget 'help() $BROWSER https://invisible-island.net/xterm/ctlseqs/ctlseqs.html' $terminfo[kf1]
bindwidget 'open-in-browser() $BROWSER .' $terminfo[kf2]

# Options
TIMEFMT=$'%P\tcpu\n%U\tuser\n%S\tsystem\n%E\ttotal'
opts=(
	# History
	histverify
	extendedhistory
	histignorealldups
	histignorespace
	sharehistory

	# Globbing
	nocaseglob
	extendedglob
	dotglob

	# Other
	autocd
	chasedots
	correctall
	promptvars
	menucomplete
	longlistjobs
); setopt $opts

# Plugin options
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Source files
z=$ZDOTDIR/zsh.d
fpath=($z/func $fpath)
autoload -Uz run-help zmv $z/func/*(:t)
for f ($z/*(.) /usr/share/zsh/plugins/*/*.plugin.zsh) . $f
