#!/bin/sh
#
# common functions
#ship() echo ${1:0:$((${#1}/2))}${2:(-$((${#2}/2)))}
#tolower(){print "${${${${${${${${${${${${${${${${${${${${${${${${${${$(<${1?})//a/A}//b/B}//c/C}//d/D}//e/E}//f/F}//g/G}//h/H}//i/I}//j/J}//k/K}//l/L}//m/M}//n/N}//o/O}//p/P}//q/Q}//r/R}//s/S}//t/T}//u/U}//v/V}//w/W}//x/X}//y/Y}//z/Z}"}

## Variables
notification=0

## Logging
pnt() {
	printf '\033[3%d;1;1m%s\033[m: %s.\n' \
		"$1" "${2:-${0##*/}}" "$3" >&2
}

log() {
	pnt 2 inf "$1"
}

die() {
	pnt 1 err "$1"
	exit "${2:-1}"
}

## Strings
findp() {
	[ "$1" = -o ] && {
		once=shift
		shift
	}

	while IFS= read -r line; do case $line in $1)
		lines="$lines
$line"
		"$once"
	esac; done < "$2"

	unset once
	lines=${lines#?}
	[ "$lines" ]
}

testglob() {
	case $2 in
		=) case $1 in $3) ;; *) return 1; esac ;;
		!=) case $1 in $3) return 1; esac ;;
	esac
}

prompt() {
	case $1 in
		y) yn='[Y/n]' ;;
		n) yn='[y/N]' ;;
	esac

	if [ "$yn" ]; then
		printf '\033[32;0;4m%s?\033[m %s ' "$2" "$yn"
		stty -icanon
		answer=$(dd ibs=1 count=1 2>/dev/null)
		: "${answer:=$1}"
		stty icanon
		printf '\n'
	else
		while [ -z "$answer" ]; do
			printf '\033[32;0;4m%s?\033[m ' "$1"
			read -r answer
		done
	fi
}

cutmd() {
	while getopts d:f:h opt; do case $opt in
		f) f=$OPTARG ;;
		d) d=$OPTARG ;;

		[h?])
			printf 'Usage: %s [-f fields] [-d delimiter]\n' \
				"${0##*/}" >&2
			exit 2
		;;
	esac; done; shift $(( OPTIND - 1 ))
	: "${f:?You must specify amount of fields.}"

	i=1; until [ "$i" -eq "$(( f + 2 ))" ]; do
		r="${r}l$i "
		i=$(( i + 1 ))
	done
	#o() while IFS=${d:=$(printf ' \t\r\n\v\f')} read -r $r; do
	o() while IFS=${d:=$IFS} read -r $r; do
		eval printf '%s\\n' "\$l$f"
	done

	if [ -t 0 ]; then
		o < "${1:?No input file specified}"
	else
		o
	fi
}

count() {
	[ "$2" ] || set -- 1 "$1"
	a=$1
	b=${2:-$1}

	until [ "$a" -eq "$(( b + 1 ))" ]; do
		c=$c$a${s:= }
		a=$(( a + 1 ))
	done

	c=${c%?}; unset a b
}

reverse_string() {
	s=$1

	while [ "$s" ]; do
		o=$o${s#"${s%?}"}
		s=${s%?}
	done

	unset s
}

get_proc() {
	unset pid prod cmdline

	# TODO case $pid, $proc, $cmdline in ...
	while read -r pid proc cmdline; do case $proc in
		$1) break
	esac; done <<-EOF
	$(ps -o pid,command -x)
	EOF

	[ "$proc" = "$1" ] || return 1
}
