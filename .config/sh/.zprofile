# Environment variables
## Default programs
export EDITOR=vim
export BROWSER=firefox-nightly
export TERMINAL=xfce4-terminal

## Compiler options
export CFLAGS='-pipe -march=native'
export CXXFLAGS="$CFLAGS"
export MAKEFLAGS=-j${#${(M)"${(f)$(< /proc/cpuinfo)}":#processor*}}

## XDG base directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
eval "${$(<$XDG_CONFIG_HOME/user-dirs.dirs)//XDG/export XDG}"

## Cleanup
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"
export FVWM_USERDIR="$XDG_CONFIG_HOME/fvwm"
export XINITRC="$XDG_CONFIG_HOME/sx/sxrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

## Convenience
export windows="/mnt/1C4EC94375351805"
export windows2="/mnt/A29E6A309E69FCE3"
export images="$winhome/Desktop/Images"
export skindir="$windows2/linux/etc"
export winhome="$windows/Users/ok"
export bin="$windows2/linux/bin"
export steamlib="$XDG_DATA_HOME/Steam/steamapps/common"
export firefox="$HOME/.mozilla/firefox/9ztk7ed7.default-nightly"
export path=(
	$path
	$CARGO_HOME/bin
	$bin/**/*(/N)
	/usr/lib/node_modules/*/bin(N)
)

export gtk3="$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
export picom="$XDG_CONFIG_HOME/picom/picom.conf"
export dunst="$XDG_CONFIG_HOME/dunst/dunstrc"
export sxhkd="$XDG_CONFIG_HOME/sxhkd/sxhkdrc"
export vim="$XDG_CONFIG_HOME/nvim/init.vim"

## Other
export TMPDIR='/tmp'
export NO_AT_BRIDGE=1
export CNF_OPTS=csipt
export MOZ_USE_XINPUT2=1
export ENV="$ZDOTDIR/.shrc"
export GTK_OVERLAY_SCROLLING=0
export MOZ_CRASHREPORTER_NO_REPORT=1
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export WINEDLLOVERRIDES='mshtml=d'
amixer -q sset Speaker 0% mute

# Other tasks
[[ $TTY != /dev/tty1 ]] && return
(( $+SSH_CLIENT )) && return

## Move every Python program to $bin/python
mv $bin/*(e:'read -r s < $REPLY && [[ $s =~ python ]]':) \
	$bin/python

## Remove every 'screenshot aborted' file
rm $XDG_PICTURES_DIR/scr/${(%):-%D{%Y-%m}}/*(.L0)

## Copy dotfiles
if [[ -d $windows ]] && [[ ! -f $TMPDIR/xran ]] {
	dots=$windows/linux/dots

	: 'if [[ -d $dots ]] {
		for dir (mpd ncmpcpp nvim sh sx sxhkd) {
			dir=$XDG_CONFIG_HOME/$dir
			[[ -d $dir ]] &&
				cp -r $dir $dots/$XDG_CONFIG_HOME
		}

		#cp -r {$XDG_CONFIG_HOME,$dots/$home}/$BROWSER
		cp -r $skindir $dots/$HOME
		#cp $ffprofile/user.js $dots/$HOME
	}'
}

## Start Xorg
if (( ! $+DISPLAY )) {
	xlog=$XDG_DATA_HOME/xorg/Xorg-stdout.log
	[[ -f $xlog ]] && mv $xlog $xlog.old

	if [[ $commands[optimus-manager] && ! -f $TMPDIR/xran ]] {
		sudo python3 -u -m optimus_manager.hooks.pre_daemon_start
		sudo python3 -u -m optimus_manager.hooks.pre_xorg_start
		print -r -- '
Section "Files"
	ModulePath "/usr/lib/nvidia"
	ModulePath "/usr/lib64/nvidia/xorg/modules"
	ModulePath "/usr/lib64/nvidia/xorg"
	ModulePath "/usr/lib64/xorg/modules"
	ModulePath "/usr/lib32/nvidia"
	ModulePath "/usr/lib32/nvidia/xorg/modules"
	ModulePath "/usr/lib32/xorg/modules"
EndSection

Section "ServerLayout"
	Identifier "layout"
	Screen 0 "nvidia"
	Inactive "integrated"
EndSection

Section "Device"
	Identifier "nvidia"
	Driver "nvidia"
	BusID "PCI:1:0:0"
EndSection

Section "Screen"
	Identifier "nvidia"
	Device "nvidia"
	Option "AllowEmptyInitialConfiguration"
EndSection

Section "Device"
	Identifier "integrated"
	Driver "modesetting"
	BusID "PCI:0:2:0"
EndSection

Section "Screen"
	Identifier "integrated"
	Device "integrated"
EndSection

Section "ServerFlags"
	Option "IgnoreABI" "1"
EndSection
' | sudo tee /etc/X11/xorg.conf.d/10-optimus-manager.conf
	}

	for (( ;; ))
		${=commands[sx]:-xinit $XINITRC -- $commands[X] \
			-nolisten tcp :0 vt1 -keeptty}
	:> $TMPDIR/xran
}
