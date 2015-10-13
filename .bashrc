#!/bin/bash

# ~/.bashrc: executed by bash(1) for non-login shells.

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# to reload ~/.bashrc do: 'exec bash'


# if not running interactively, don't do anything
#[ -z "$PS1" ] && return
[[ "$-" != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
# shellcheck disable=SC2154
if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429); (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
	;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc)
if [ -f /etc/bash_completion ] && ! shopt -oq posix ; then
	. /etc/bash_completion
fi

# Environmental variables
# - java
#export JAVA_HOME=/usr/lib/fjsdk
#export JAVA_HOME=/usr/local/java/j2sdk
#export JAVA_HOME=/usr/local/java/j2re
#export JAVA_HOME="/usr/lib/jvm/java-1.5.0-sun/jre/"
#export JAVA_HOME="/usr/lib/jvm/java-6-sun"
if [ -d /usr/lib/jvm/java-7-openjdk-amd64 ] ; then
    export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
fi
# - catalog file (XML/DocBook URL resolution)
if [ -f /etc/xml/catalog ] ; then
    export XML_CATALOG_FILES="/etc/xml/catalog"
fi
if [ -f /etc/sgml/catalog ] ; then
    export SGML_CATALOG_FILES="/etc/sgml/catalog"
fi
# - locale
export LANG="en_AU.UTF-8"
# - pstill
if [ -d /usr/local/pstill_dist ] ; then
    export PSTILL_PATH="/usr/local/pstill_dist"
    export PSTILL_LICENSE="DavidNebauer=4721e23f1ffed02d\!FSNIGSRJ"
fi
# - docbook/xml configuration
if [ -d "{HOME}/conf/xml" ] ; then
    export DBN_ROOT="${HOME}/conf/xml"
fi
# - shellscript libraries
if [ -f /usr/share/libdncommon-bash/liball ] ; then
    export DN_BASH_FNS="/usr/share/libdncommon-bash/liball"
fi
# - path
#   + cask
if [ -d "${HOME}/.cask/bin" ] ; then
    PATH="${PATH}:${HOME}/.cask/bin"
fi
#   + android sdk
if [ -d "${HOME}/data/computing/projects/android/sdk/platform-tools" ] ; then
    PATH="${PATH}:${HOME}/data/computing/projects/android/sdk/platform-tools"
fi
#   + docbook/xml configure
if [ -z "${DBN_ROOT}" -a -d "${DBN_ROOT}/bin" ] ; then
    PATH="${PATH}:${DBN_ROOT}/bin"
fi
#   + games
if [ -d /usr/games ] ; then
    PATH="${PATH}:/usr/games/"
fi
if [ -d /usr/local/games ] ; then
    PATH="${PATH}:/usr/local/games"
fi
#   + pstill_dist
if [ -d /usr/local/pstill_dist ] ; then
    PATH="${PATH}:/usr/local/pstill_dist"
fi
#   + npm/nodejs
if [ -d /cygdrive/c/Program\ Files/nodejs ] ; then
    PATH="${PATH}:/cygdrive/c/Program Files/nodejs"
fi
#   + hasktags
if [ -d /cygdrive/c/dtn/AppData/Roaming/cabal/bin/hasktags.exe ] ; then
    PATH="${PATH}:/cygdrive/c/dtn/AppData/Roaming/cabal/bin/hasktags.exe"
fi

# cdargs (cv) support
if [ -f /usr/share/doc/cdargs/examples/cdargs-bash.sh ] ; then
	. /usr/share/doc/cdargs/examples/cdargs-bash.sh
fi

# keyboard keys
#xmodmap ${HOME}/.xmodmap-`uname -n`

# load apparix commands (to, bm, portal)
if [ -f "${HOME}/.apparixfunctions" ] ; then
    . "${HOME}/.apparixfunctions"
fi

# added by perl module CPAN but commented out by user
#export PERL_LOCAL_LIB_ROOT="${HOME}/perl5";
#export PERL_MB_OPT="--install_base ${HOME}/perl5";
#export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5";
#export PERL5LIB="${HOME}/perl5/lib/perl5/x86_64-linux-gnu-thread-multi:${HOME}/perl5/lib/perl5";
#export PATH="${HOME}/perl5/bin:$PATH";
