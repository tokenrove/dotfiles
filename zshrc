#!/usr/bin/zsh
#
# $Id: zshrc,v 1.17 2001/08/14 16:46:32 tek Exp $
#

WATCH='all'
HOSTNAME=`hostname`
EMAILADDRESS=tek@wiw.org

export PATH=$PATH:/usr/X11R6/bin:/usr/local/pgsql/bin:/mu/cross

case $HOSTNAME in
  distorted) 
  	EMACS=`where xemacs`
        export PORTSDIR=/usr/ports
	export BSDSRCDIR=/usr/src
        alias n='noose -q check'
#	alias less=zless
        ;;
  *) 
        if [ -x `where zile` ]; then
          EMACS=`where zile`
	elif [ -x `where xemacs` ]; then
          EMACS=`where xemacs`
        else
	  EMACS=/usr/bin/emacs 
        fi
	;;
esac

CVSROOT="tek@distorted.wiw.org:/home/tek/cvs"
CVS_RSH="ssh"

FULLNAME="Julian E. C. Squires"
MAIL="$HOME/Mail/inbox"

export WATCH CVSROOT CVS_RSH EMAILADDRESS FULLNAME VISUAL MAIL

setopt AUTO_MENU NO_BEEP NO_BAD_PATTERN

# Aliases
alias ls='ls $LS_OPTIONS'
alias newscreen='ssh-agent screen'
alias wterm='wterm -tr -sb'

#alias x='startx -- -bpp 16'
if [ `uname` = "Linux" ]; then
  alias root='su -c sh'
fi
#alias info='emacs -f info'
alias j=jobs

function dmalloc { eval `command dmalloc -b $*` }

alias sp='sidplay -16 -f44100 -ss'
alias x='xemacs -nw'

# EOF zshrc
#!/usr/bin/zsh
#
# $Id: zshrc,v 1.16 1999/12/07 19:45:27 tek Exp $
#

# Aliases and such
alias ls='ls $LS_OPTIONS'
alias emacs=zile

setopt AUTO_MENU NO_BEEP NO_BAD_PATTERN

# EOF zshrc
#
# completions (lots taken from the examples)
# some of the examples have been updated to fit with reality
#
#------------------------------------------------------------------------------
hosts=(distorted.wiw.org raptor.york-consulting.com balance.wiw.org)
ports=( "${(@)${(@)${(@f)$(</etc/services)}:#\#*}%%[ 	]*}" )
groups=( ${${(s: :)$(</etc/group)}%%:*} )
ftphosts=(distorted.wiw.org)

# Completion for zsh builtins.
compctl -z -P '%' bg
compctl -j -P '%' fg jobs disown
compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' wait
compctl -A shift
compctl -c type whence where which
compctl -m -x 'W[1,-*d*]' -n - 'W[1,-*a*]' -a - 'W[1,-*f*]' -F -- unhash
compctl -m -q -S '=' -x 'W[1,-*d*] n[1,=]' -/ - \
	'W[1,-*d*]' -n -q -S '=' - 'n[1,=]' -/g '*(*)' -- hash
compctl -F functions unfunction
compctl -k '(al dc dl do le up al bl cd ce cl cr
	dc dl do ho is le ma nd nl se so up)' echotc
compctl -a unalias
compctl -v getln getopts read unset vared
compctl -v -S '=' -q declare export integer local readonly typeset
compctl -eB -x 'p[1] s[-]' -k '(a f m r)' - \
	'C[1,-*a*]' -ea - 'C[1,-*f*]' -eF - 'C[-1,-*r*]' -ew -- disable
compctl -dB -x 'p[1] s[-]' -k '(a f m r)' - \
	'C[1,-*a*]' -da - 'C[1,-*f*]' -dF - 'C[-1,-*r*]' -dw -- enable
compctl -k "(${(j: :)${(f)$(limit)}%% *})" limit unlimit
compctl -l '' -x 'p[1]' -f -- . source
# Redirection below makes zsh silent when completing unsetopt xtrace
compctl -s '$({ unsetopt kshoptionprint; setopt } 2>/dev/null)' + -o + -x 's[no]' -o -- unsetopt
compctl -s '$({ unsetopt kshoptionprint; unsetopt } 2>/dev/null)' + -o + -x 's[no]' -o -- setopt
compctl -s '${^fpath}/*(N:t)' autoload
compctl -b -x 'W[1,-*[DAN]*],C[-1,-*M]' -s '$(bindkey -l)' -- bindkey
compctl -c -x 'C[-1,-*k]' -A - 'C[-1,-*K]' -F -- compctl
compctl -x 'C[-1,-*e]' -c - 'C[-1,-[ARWI]##]' -f -- fc
compctl -x 'p[1]' - 'p[2,-1]' -l '' -- sched
compctl -x 'C[-1,[+-]o]' -o - 'c[-1,-A]' -A -- set
compctl -b -x 'w[1,-N] p[3]' -F -- zle
compctl -s '${^module_path}/*(N:t:r)' -x \
	'W[1,-*(a*u|u*a)*],W[1,-*a*]p[3,-1]' -B - \
	'W[1,-*u*]' -s '$(zmodload)' -- zmodload

# Anything after nohup is a command by itself with its own completion
compctl -l '' nohup noglob exec nice eval - time rusage
compctl -l '' -x 'p[1]' -eB -- builtin
compctl -l '' -x 'p[1]' -em -- command
compctl -x 'p[1]' -c - 'p[2,-1]' -k signals -- trap
#------------------------------------------------------------------------------
# kill takes signal names as the first argument after -, but job names after %
# or PIDs as a last resort
compctl -j -P '%' + -s '`ps x | tail +2 | cut -c1-5`' + \
	-x 's[-] p[1]' -k "($signals[1,-3])" -- kill
#------------------------------------------------------------------------------
compctl -s '$(groups)' + -k groups newgrp
compctl -f -x 'p[1], p[2] C[-1,-*]' -k groups -- chgrp
compctl -f -x 'p[1] n[-1,.], p[2] C[-1,-*] n[-1,.]' -k groups - \
	'p[1], p[2] C[-1,-*]' -u -S '.' -q -- chown
compctl -/g '*.x' rpcgen
compctl -u -x 's[+] c[-1,-f],s[-f+]' -W ~/Mail -f - \
	's[-f],c[-1,-f]' -f -- mail elm
compctl -x 'c[-1,-f]' -W ~/Mail -f -- pine
#------------------------------------------------------------------------------
compctl -s "\$(awk '/^[a-zA-Z0-9][^ 	]+:/ {print \$1}' FS=: [mM]akefile)" -x \
	'c[-1,-f]' -f -- make gmake pmake
#------------------------------------------------------------------------------
# tar
tarnames () {
	# Completion function for use with tar:
	# get the names of files in the tar archive to extract.
	#
	# The main claim to fame of this particular function is that it
	# completes directories in the tar-file in a manner very roughly
	# consistent with `compctl -f'.  There are two bugs:  first, the whole
	# path prefix up to the present is listed with ^D, not just the new
	# part to add; second, after a unique completion a space is always
	# inserted, even if the completion ends with a slash.  These are
	# currently limitations of zsh.
	#
	# This only works for the (fairly common) tar argument style where
	# the arguments are bunched into the first argument, and the second
	# argument is the name of the tarfile.  For example,
	#  tar xvzf zsh-3.1.2.tar.gz ...
	# You can only use compressed/gzipped files if tar is GNU tar,
	# although the correct name for the tar programme will be inferred.

	local line list=tf
	read -cA line
	# $line[2] is the first argument:  check for possible compression args.
	# (This is harmless when used with non-GNU tar, but then the file must
	# be uncompressed to be able to use it with tar anyway.)
	[[ $line[2] = *[Zz]* ]] && list=tfz
	# $line[1] is the command name:  something like tar or gnutar.
	# $line[3] is the name of the tar archive.

	# cache contents for multiple completion: note tar_cache_name
	# and tar_cache_list are not local.  Assumes all files with the
	# same name are the same file, even if in different directories:
	# you can trick it with $PWD/file on the command line.
	if [[ $line[3] != $tar_cache_name ]]; then
	  tar_cache_list=($($line[1] $list $line[3]))
	  tar_cache_name=$line[3]
	fi

	# Now prune the list to include only appropriate directories.
	local file new
	reply=()
	if [[ $1 = */* ]]; then
	  local sofar=${1%/*}/
	  for file in $tar_cache_list; do
	    if [[ $file = $sofar* ]]; then
	      new=${file#$sofar}
	      if [[ $new = */* ]]; then
		new=$sofar${new%%/*}/
	      else
		new=$file
	      fi
	      if [[ $1 != */ || $new != $1 ]]; then
		reply=($reply $new)
	      fi
	    fi
	  done
	else
	  for file in $tar_cache_list; do
	    if [[ $file = */* ]]; then
	      new=${file%%/*}/
	    else
	      new=$file
	    fi
	    reply=($reply $new)
	  done
	fi
}

compctl -f \
	-x 'p[2] C[-1,*(z*f|f*z)*]' -/g '*.(taz|tar.(gz|z|Z)|tgz)' \
	- 'p[2] C[-1,*(Z*f|f*Z)*]' -/g '*.(tar.Z|taz)' \
	- 'p[2] C[-1,*f*]' -/g '*.tar' \
	- 'p[1] N[-1,ctxvzZ]' -k "(v z f)" \
	- 'p[1] s[]' -k "(c t x)" -S '' \
	- 'p[3,-1] W[1,*x*]' -K tarnames \
	-- tar gtar gnutar
#------------------------------------------------------------------------------
# rmdir only real directories
compctl -/g '*(/)' rmdir dircmp
#------------------------------------------------------------------------------
# cd/pushd only directories or symbolic links to directories
#compctl -/ cd chdir dirs pushd
compctl -g '*(-/)' cd pushd

# Another possibility for cd/pushd is to use it in conjunction with the
# cdmatch function (in the Functions subdirectory of zsh distribution).
#compctl -K cdmatch -S '/' -q -x 'p[2]' -Q -K cdmatch2 - \
#	'S[/][~][./][../]' -g '*(-/)' + -g '*(-/D)' - \
#	'n[-1,/]' -K cdmatch -S '/' -q -- cd chdir pushd
#------------------------------------------------------------------------------
# If the command is rsh, make the first argument complete to hosts and treat the
# rest of the line as a command on its own.
compctl -k hosts -x 'p[2,-1]' -l '' -- rsh

# rlogin takes hosts and users after `-l'
compctl -k hosts -x 'c[-1,-l]' -u -- rlogin

# rcp: match users, hosts and files initially.  Match files after a :, or hosts
# after an @.  If one argument contains a : then the other matches files only.
# Not quite perfect; compctl just isn't up to it yet.
compctl -u -k hosts -f -x 'n[1,:]' -f - 'n[1,@]' -k hosts -S ':' - \
	'p[1] W[2,*:*]' -f - 'p[1] W[2,*?*]' -u -k hosts -S ':' - \
	'p[2] W[1,*:*]' -f - 'p[2] W[1,*?*]' -u -k hosts -S ':' -- rcp

compctl -k hosts host rup rusers ping
#------------------------------------------------------------------------------
# strip, profile, and debug only executables.  The compctls for the
# debuggers could be better, of course.
compctl -/g '*(*)' strip gprof adb dbx xdbx ups
compctl -/g '*.[ao]' -/g '*(*)' nm
#------------------------------------------------------------------------------
# shells: compctl needs some more enhancement to do -c properly.
compctl -f -x 'C[-1,-*c]' -c - 'C[-1,[-+]*o]' -o -- bash ksh sh zsh
#------------------------------------------------------------------------------
# su takes a username and args for the shell.
compctl -u -x 'w[1,-]p[3,-1]' -l sh - 'w[1,-]' -u - 'p[2,-1]' -l sh -- su
#------------------------------------------------------------------------------
# Run ghostscript on postscript files, but if no postscript file matches what
# we already typed, complete directories as the postscript file may not be in
# the current directory.
compctl -/g '*.(e|E|)(ps|PS|pdf|PDF)' \
	gs ghostview nup psps pstops psmulti psnup psselect
#------------------------------------------------------------------------------
# Similar things for tex, texinfo and dvi files.
compctl -/g '*.tex*' {pdf,}{,la,gla,ams{la,},{g,}sli}tex texi2dvi
compctl -/g '*.dvi' xdvi dvips
#------------------------------------------------------------------------------
# For rcs users, co and rlog from the RCS directory.  We don't want to see
# the RCS and ,v though.
compctl -g 'RCS/*(:s@RCS/@@:s/,v//)' co rlog rcs rcsdiff
#------------------------------------------------------------------------------
# gzip uncompressed files, but gzip -d only gzipped or compressed files
compctl -x 'R[-*[dt],^*]' -/g '*.(gz|z|Z|t[agp]z|tarZ|tz)' + -f - \
    's[]' -/g '^*(.(tz|gz|t[agp]z|tarZ|zip|ZIP|jpg|JPG|gif|GIF|[zZ])|[~#])' \
    + -f -- gzip
compctl -/g '*.(gz|z|Z|t[agp]z|tarZ|tz)' gunzip gzcat zcat
compctl -/g '*.Z' uncompress zmore
compctl -/g '*.F' melt fcat
#------------------------------------------------------------------------------
# ftp takes hostnames
compctl -k ftphosts ftp

# Some systems have directories containing indices of ftp servers.
# For example: we have the directory /home/ftp/index/INDEX containing
# files of the form `<name>-INDEX.Z', this leads to:
#compctl -g '/home/ftp/index/INDEX/*-INDEX.Z(:t:r:s/-INDEX//)' ftp tftp
#------------------------------------------------------------------------------
# Change default completion (see the multicomp function in the Function
# subdirectory of the zsh distribution).
#compctl -D -f + -U -K multicomp
# If completion of usernames is slow for you, you may want to add something
# like
#    -x 'C[0,*/*]' -f - 's[~]' -S/ -k users + -u
# where `users' contains the names of the users you want to complete often.
# If you want to use this and to be able to complete named directories after
# the `~' you should add `+ -n' at the end
#------------------------------------------------------------------------------
# This is to complete all directories under /home, even those that are not
# yet mounted (if you use the automounter).

# This is for NIS+ (e.g. Solaris 2.x)
#compctl -Tx 's[/home/] C[0,^/home/*/*]'  -S '/' -s '$(niscat auto_home.org_dir | \
#	awk '\''/export\/[a-zA-Z]*$/ {print $NF}'\'' FS=/)'

# And this is for YP (e.g. SunOS4.x)
#compctl -Tx 's[/home/] C[0,^/home/*/*]' -S '/' -s '$(ypcat auto.home | \
#	awk '\''/export\/[a-zA-Z]*$/ {print $NF}'\'' FS=/)'
#------------------------------------------------------------------------------
# Find is very system dependent, this one is for GNU find.
# Note that 'r[-exec,;]' must come first
if [[ -r /proc/filesystems ]]; then
    # Linux
    filesystems='"${(@)${(@f)$(</proc/filesystems)}#*	}"'
else
    filesystems='ufs 4.2 4.3 nfs tmp mfs S51K S52K'
fi
compctl -x 'r[-exec,;][-ok,;]' -l '' - \
's[-]' -s 'daystart {max,min,}depth follow noleaf version xdev
	{a,c,}newer {a,c,m}{min,time} empty false {fs,x,}type gid inum links
	{i,}{l,}name {no,}{user,group} path perm regex size true uid used
	exec {f,}print{f,0,} ok prune ls' - \
	'p[1]' -g '. .. *(-/)' - \
	'C[-1,-((a|c|)newer|fprint(|0|f))]' -f - \
	'c[-1,-fstype]' -s $filesystems - \
	'c[-1,-group]' -k groups - \
	'c[-1,-user]' -u -- find
#------------------------------------------------------------------------------
# Generic completion for C compiler.
compctl -/g "*.[cCoa]" -x 's[-I]' -/ - \
	's[-l]' -s '${(s.:.)^LD_LIBRARY_PATH}/lib*.a(:t:r:s/lib//)' -- cc
#------------------------------------------------------------------------------
# GCC completion, by Andrew Main
# completes to filenames (*.c, *.C, *.o, etc.); to miscellaneous options after
# a -; to various -f options after -f (and similarly -W, -g and -m); and to a
# couple of other things at different points.
# The -l completion is nicked from the cc compctl above.
# The -m completion should be tailored to each system; the one below is i386.
compctl -/g '*.([cCmisSoak]|cc|cxx|ii|k[ih])' -x \
	's[-l]' -s '${(s.:.)^LD_LIBRARY_PATH}/lib*.a(:t:r:s/lib//)' - \
	'c[-1,-x]' -k '(none c objective-c c-header c++ cpp-output
	assembler assembler-with-cpp)' - \
	'c[-1,-o]' -f - \
	'C[-1,-i(nclude|macros)]' -/g '*.h' - \
	'C[-1,-i(dirafter|prefix)]' -/ - \
	's[-B][-I][-L]' -/ - \
	's[-fno-],s[-f]' -k '(all-virtual cond-mismatch dollars-in-identifiers
	enum-int-equiv external-templates asm builtin strict-prototype
	signed-bitfields signd-char this-is-variable unsigned-bitfields
	unsigned-char writable-strings syntax-only pretend-float caller-saves
	cse-follow-jumps cse-skip-blocks delayed-branch elide-constructors
	expensive-optimizations fast-math float-store force-addr force-mem
	inline-functions keep-inline-functions memoize-lookups default-inline
	defer-pop function-cse inline peephole omit-frame-pointer
	rerun-cse-after-loop schedule-insns schedule-insns2 strength-reduce
	thread-jumps unroll-all-loops unroll-loops)' - \
	's[-g]' -k '(coff xcoff xcoff+ dwarf dwarf+ stabs stabs+ gdb)' - \
	's[-mno-][-mno][-m]' -k '(486 soft-float fp-ret-in-387)' - \
	's[-Wno-][-W]' -k '(all aggregate-return cast-align cast-qual
	char-subscript comment conversion enum-clash error format id-clash-6
	implicit inline missing-prototypes missing-declarations nested-externs
	import parentheses pointer-arith redundant-decls return-type shadow
	strict-prototypes switch template-debugging traditional trigraphs
	uninitialized unused write-strings)' - \
	's[-]' -k '(pipe ansi traditional traditional-cpp trigraphs pedantic
	pedantic-errors nostartfiles nostdlib static shared symbolic include
	imacros idirafter iprefix iwithprefix nostdinc nostdinc++ undef)' \
	-X 'Use "-f", "-g", "-m" or "-W" for more options' -- gcc g++
#------------------------------------------------------------------------------
# There are (at least) two ways to complete manual pages.  This one is
# extremely memory expensive if you have lots of man pages
man_var() {
    man_pages=( ${^manpath}/man*/*(N:t:r) )
    compctl -k man_pages -x 'C[-1,-P]' -m - \
	    'R[-*l*,;]' -/g '*.(man|[0-9](|[a-z]))' -- man
    reply=( $man_pages )
}
compctl -K man_var -x 'C[-1,-P]' -m - \
	'R[-*l*,;]' -/g '*.(man|[0-9](|[a-z]))' -- man

# This one isn't that expensive but somewhat slower
man_glob () {
   local a
   read -cA a
   if [[ $a[2] = -s ]] then         # Or [[ $a[2] = [0-9]* ]] for BSD
     reply=( ${^manpath}/man$a[3]/$1*$2(N:t:r) )
   else
     reply=( ${^manpath}/man*/$1*$2(N:t:r) )
   fi
}
#compctl -K man_glob -x 'C[-1,-P]' -m - \
#	'R[-*l*,;]' -/g '*.(man|[0-9nlpo](|[a-z]))' -- man
#------------------------------------------------------------------------------
# xsetroot: gets possible colours, cursors and bitmaps from wherever.
# Uses two auxiliary functions.  You might need to change the path names.
Xcolours() {
  reply=( ${(L)$(awk '{ if (NF = 4) print $4 }' \
	< /usr/openwin/lib/X11/rgb.txt)} )
}
Xcursor() {
  reply=( $(sed -n 's/^#define[	 ][ 	]*XC_\([^ 	]*\)[ 	].*$/\1/p' \
	  < /usr/include/X11/cursorfont.h) )
}
compctl -k '(-help -def -display -cursor -cursor_name -bitmap -mod -fg -bg
	-grey -rv -solid -name)' -x \
	'c[-1,-display]' -s '$DISPLAY' -k hosts -S ':0' - \
	'c[-1,-cursor]' -f -  'c[-2,-cursor]' -f - \
	'c[-1,-bitmap]' -g '/usr/include/X11/bitmaps/*' - \
	'c[-1,-cursor_name]' -K Xcursor - \
	'C[-1,-(solid|fg|bg)]' -K Xcolours -- xsetroot
#------------------------------------------------------------------------------
# dd
compctl -k '(if of conv ibs obs bs cbs files skip file seek count)' \
	-S '=' -x 's[if=], s[of=]' -f - 'C[0,conv=*,*] n[-1,,], s[conv=]' \
	-k '(ascii ebcdic ibm block unblock lcase ucase swap noerror sync)' \
	-q -S ',' - 'n[-1,=]' -X '<number>'  -- dd
#------------------------------------------------------------------------------
# Various MH completions by Peter Stephenson
# You may need to edit where it says *Edit Me*.

# The following three functions are best autoloaded.
# mhcomp completes folders (including subfolders),
# mhfseq completes sequence names and message numbers,
# mhfile completes files in standard MH locations.

function mhcomp {
  # Completion function for MH folders.
  # Works with both + (rel. to top) and @ (rel. to current).
  local nword args pref char mhpath
  read -nc nword
  read -cA args

  pref=$args[$nword]
  char=$pref[1]
  pref=$pref[2,-1]

  # The $(...) here accounts for most of the time spent in this function.
  if [[ $char = + ]]; then
  #    mhpath=$(mhpath +)
  # *Edit Me*: use a hard wired value here: it's faster.
    mhpath=~/Mail
  elif [[ $char = @ ]]; then
    mhpath=$(mhpath)
  fi

  eval "reply=($mhpath/$pref*(N-/))"

  # I'm frankly amazed that this next step works, but it does.
  reply=(${reply#$mhpath/})
}

mhfseq() {
  # Extract MH message names and numbers for completion.  Use of the
  # correct folder, if it is not the current one, requires that it
  # should be the previous command line argument.  If the previous
  # argument is `-draftmessage', a hard wired draft folder name is used.

  local folder foldpath words pos nums
  read -cA words
  read -cn pos

  # Look for a folder name.
  # First try the previous word.
  if [[ $words[$pos-1] = [@+]* ]]; then
    folder=$words[$pos-1]
  # Next look and see if we're looking for a draftmessage
  elif [[ $words[$pos-1] = -draftmessage ]]; then
    # *Edit Me*:  shortcut -- hard-wire draftfolder here
    # Should really look for a +draftfolder argument.
    folder=+drafts
  fi
  # Else use the current folder ($folder empty)

  if [[ $folder = +* ]]; then
  # *Edit Me*:  use hard-wired path with + for speed.
    foldpath=~/Mail/$folder[2,-1]
  else
    foldpath=$(mhpath $folder)
  fi

  # Extract all existing message numbers from the folder.
  nums=($foldpath/<->(N:t))
  # If that worked, look for marked sequences.
  # *Edit Me*: if you never use non-standard sequences, comment out
  # or delete the next three lines.
  if (( $#nums )); then
    nums=($nums $(mark $folder | awk -F: '{print $1}'))
  fi

  # *Edit Me*:  `unseen' is the value of Unseen-Sequence, if it exists;
  set -A reply next cur prev first last all unseen $nums

}

mhfile () {
  # Find an MH file; for use with -form arguments and the like.
  # Use with compctl -K mhfile.

  local mhfpath file
  # *Edit Me*:  Array containing all the places MH will look for templates etc.
  mhfpath=(~/Mail /usr/local/lib/MH)

  # Emulate completeinword behaviour as appropriate
  local wordstr
  if [[ -o completeinword ]]; then
    wordstr='$1*$2'
  else
    wordstr='$1$2*'
  fi

  if [[ $1$2 = */* ]]; then
    # path given: don't search MH locations
    eval "reply=($wordstr(.N))"
  else
    # no path:  only search MH locations.
    eval "reply=(\$mhfpath/$wordstr(.N:t))"
  fi
}

# Note: you must type the initial + or @ of a folder name to get
# completion, even in places where only folder names are allowed.
# Abbreviations for options are not recognised.  Hit tab to complete
# the option name first.
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - \
  's[-]' -k "(all fast nofast header noheader help list nolist \
  pack nopack pop push recurse norecurse total nototal)" -- folder
compctl -K mhfseq -x 's[+][@],c[-1,-draftfolder] s[+][@]' \
  -K mhcomp -S / -q - 'c[-1,-draftmessage]' -K mhfseq - \
  'C[-1,-(editor|whatnowproc)]' -c - \
  's[-]' -k "(draftfolder draftmessage nodraftfolder editor noedit \
  file form use nouse whatnowproc nowhatnowproc help)" - \
  'c[-1,-form]' -K mhfile -- comp
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - \
  's[-]' -k "(audit noaudit changecur nochangecur form format \
  file silent nosilent truncate notruncate width help)" - \
  'C[-1,-(audit|form)]' -K mhfile - 'c[-1,-file]' -f + -- inc
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - \
  's[-]' -k "(sequence add delete list public nopublic zero nozero help)" -- \
  mark
compctl -K mhfseq -x 's[+][@]' \
  -K mhcomp -S / -q - 'c[-1,-file]' -f - 'c[-1,-rmmprov]' -c - \
  's[-]' -k "(draft link nolink preserve nopreserve src file \
  rmmproc normmproc help)" -- refile
compctl -K mhfseq -x 's[+][@]' \
  -K mhcomp -S / -q - 'c[-1,-draftmessage]'  -K mhfseq -\
  's[-]' -k "(annotate noannotate cc nocc draftfolder nodraftfolder \
  draftmessage editor noedit fcc filter form inplace noinplace query \
  noquery width whatnowproc nowhatnowproc help)" - 'c[-1,(cc|nocc)]' \
  -k "(all to cc me)" - 'C[-1,-(filter|form)]' -K mhfile - \
  'C[-1,-(editor|whatnowproc)]' -c -- repl
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - \
  's[-]' -k "(clear noclear form format header noheader reverse noreverse \
  file help width)" - 'c[-1,-file]' -f - 'c[-1,-form]' -K mhfile -- scan
compctl -K mhfseq -x 's[+][@]'  -K mhcomp -S / -q - \
  's[-]' -k "(draft form moreproc nomoreproc header noheader \
   showproc noshowproc length width help)" - 'C[-1,-(show|more)proc]' -c - \
   'c[-1,-file]' -f - 'c[-1,-form]' -K mhfile - \
   'c[-1,-length]' -s '$LINES' - 'c[-1,-width]' -s '$COLUMNS' -- show next prev
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - 's[-]' \
  -k "(help)" -- rmm
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - \
  's[-]' -k "(after before cc date datefield from help list nolist \
  public nopublic search sequence subject to zero nozero not or and \
  lbrace rbrace)" -- pick
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - 's[-]' \
  -k "(alias check draft draftfolder draftmessage help nocheck \
  nodraftfolder)" -- whom
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - 's[-]' \
  -k "(file part type list headers noheaders realsize norealsize nolist \
  show serialonly noserialonly form pause nopause noshow store auto noauto \
  nostore cache nocache rcache wcache check nocheck ebcdicsafe noebcdicsafe \
  rfc934mode norfc934mode verbose noverbose help)" - \
  'c[-1,-file]' -f - 'c[-1,-form]' -K mhfile - \
  'C[-1,-[rw]cache]' -k '(public private never ask)' -- mhn
compctl -K mhfseq -x 's[+][@]' -K mhcomp -S / -q - 's[-]' -k '(help)' -- mhpath
#------------------------------------------------------------------------------
# CVS
#
cvscmds=(add admin rcs checkout commit diff rdiff export history import log rlog
         release remove status tag rtag update annotate)
cvsignore="*~ *# .#* *.o *.a CVS . .."

compctl -k cvscmds \
    -x "c[-1,-D]" -k '(today yesterday 1\ week\ ago)' \
    - "c[-1,-m]" -k '(bugfix cosmetic\ fix ... added\ functionality foo)' \
    - "c[-1,-F]" -f \
    - "c[-1,-r]" -K cvsrevisions \
    - "c[-1,-I]" -f \
    - "R[add,;]" -K cvsaddp \
    - "R[(admin|rcs),;]" -/K cvstargets \
    - "R[(checkout|co),;]" -K cvsrepositories \
    - "R[(commit|ci),;]" -/K cvstargets \
    - "R[(r|)diff,;]" -/K cvstargets \
    - "R[export,;]" -f \
    - "R[history,;]" -/K cvstargets \
    - "R[history,;] c[-1,-u]" -u \
    - "R[import,;]" -K cvsrepositories \
    - "R[(r|)log,;]" -/K cvstargets \
    - 'R[(r|)log,;] s[-w] n[-1,,],s[-w]' -u -S , -q \
    - "R[rel(|ease),;]" -f \
    - "R[(remove|rm),;] R[-f,;]" -/K cvstargets \
    - "R[(remove|rm),;]" -K cvsremovep \
    - "R[status,;]" -/K cvstargets \
    - "R[(r|)tag,;]" -/K cvstargets \
    - "R[up(|date),;]" -/K cvstargets \
    - "R[annotate,;]" -/K cvstargets \
    -- cvs 

compctl -/K cvstargets cvstest 

cvsprefix() {
    local nword args f
    read -nc nword; read -Ac args
    pref=$args[$nword]
    if [[ -d $pref:h && ! -d $pref ]]; then
	pref=$pref:h
    elif [[ $pref != */* ]]; then
	pref=
    fi
    [[ -n "$pref" && "$pref" != */ ]] && pref=$pref/
}

cvsentries() {
    setopt localoptions nullglob unset
    if [[ -f ${pref}CVS/Entries ]]; then
	reply=( "${pref}${(@)^${(@)${(@)${(f@)$(<${pref}CVS/Entries)}:#D*}#/}%%/*}" )
    fi
}

cvstargets() {
    local pref
    cvsprefix
    cvsentries
}

cvsrevisions() {
    reply=( "${(@)${(@)${(@M)${(@f)$(cvs -q status -vl .)}:#	*}##[ 	]##}%%[ 	]*}" )
}

cvsrepositories() {
    local root=$CVSROOT
    [[ -f CVS/Root ]] && root=$(<CVS/Root)
    reply=(
	$root/^CVSROOT(:t)
	"${(@)${(@M)${(@f)$(<$root/CVSROOT/modules)}:#[^#]*}%%[ 	]*}"
    )
}

cvsremovep() {
    local pref
    cvsprefix
    cvsentries
    setopt localoptions unset
    local omit
    omit=( ${pref}*(D) )
    eval 'reply=( ${reply:#('${(j:|:)omit}')} )'
}

cvsaddp() {
    local pref
    cvsprefix
    cvsentries
    setopt localoptions unset
    local all omit
    all=( ${pref}*(D) )
    omit=( $reply ${pref}${^${=cvsignore}} )
    [[ -r ~/.cvsignore ]] && omit=( $omit ${pref}${^$(<~/.cvsignore)} )
    [[ -r ${pref}.cvsignore ]] && omit=( $omit ${pref}${^$(<${pref}.cvsignore)} )
    eval 'reply=( ${all:#('${(j:|:)omit}')} )' 
}

#------------------------------------------------------------------------------
# RedHat Linux rpm utility
#
compctl -s '$(rpm -qa)' \
	-x 's[--]' -s 'oldpackage percent replacefiles replacepkgs noscripts
		       root excludedocs includedocs test upgrade test clean
		       short-circuit sign recompile rebuild resign querytags
		       queryformat version help quiet rcfile force hash' - \
	's[ftp:]' -P '//' -s '$(</u/zsh/ftphosts)' -S '/' - \
	'c[-1,--root]' -/ - \
	'c[-1,--rcfile]' -f - \
	'p[1] s[-b]' -k '(p l c i b a)' - \
	'c[-1,--queryformat] N[-1,{]' \
		-s '"${(@)${(@f)$(rpm --querytags)}#RPMTAG_}"' -S '}' - \
	'W[1,-q*] C[-1,-([^-]*|)f*]' -f - \
	'W[1,-i*], W[1,-q*] C[-1,-([^-]*|)p*]' \
		-/g '*.rpm' + -f -- rpm
#------------------------------------------------------------------------------
compctl -u -x 'c[-1,-w]' -f -- ac
compctl -/g '*.m(.)' mira
#------------------------------------------------------------------------------
# talk completion: complete local users, or users at hosts listed via rwho
compctl -K talkmatch talk ytalk ytalk3
function talkmatch {
    local u
    reply=($(users))
    for u in "${(@)${(@f)$(rwho 2>/dev/null)}%%:*}"; do
	reply=($reply ${u%% *}@${u##* })
    done
}
#------------------------------------------------------------------------------
# Linux mount
comp_fsmount () {
    local tmp; if [[ $UID = 0 ]]; then tmp=""; else tmp="user"; fi
    sed -n -e "s|^[^# 	][^ 	]*[ 	][ 	]*\(/[^ 	]*\)[ 	].*$tmp.*|\1|p" /etc/fstab
}
comp_nfsmount () {
    local cmd args host
    read -Ac cmd; read -cn where
    host=${${cmd[$where]}%%:*}
    reply=("${(@f)$(showmount -e $host | sed -n -e "s|^/\([^ ]*\) .*|$host:/\1|p")}")
}
compctl -s '$(mount | \
	      sed -e "s/^[^ ]* on \\([^ ]*\\) type.*/\\1/"'"$(
	      if [[ ! $UID = 0 ]]; then
		  echo ' | egrep "^${(j:|:)$(comp_fsmount)}\$"'
	      fi)"')' umount
compctl -s '$(comp_fsmount)' + \
	-x 'S[/]' -f -- + \
	-x 'C[0,*:*]' -K comp_nfsmount -- + \
	-s '$(< /etc/hosts)' \
	mount
#------------------------------------------------------------------------------
# Lynx (web browser)
compctl -k '(http:// file: ftp:// gopher:// news://)' -S '' \
        -x 's[ftp://]' -k ftphosts -S/ \
        - 'n[1,://]' -k hosts -S/ \
        - 's[file:/]' -/g '*.html' -W/ \
	- 's[file:]' -s '~+' -S '/' \
        - 's[-]' -k '(anonymous auth base book buried_news cache case
		cfg child cookies crawl display dump editor emacskeys
		enable_scrollback error_file fileversions force_html
		from ftp get_data head help historical homepage
		image_links index link localhost locexec mime_header
		minimal newschunksize newsmaxchunk nobrowse noexec
		nofilereferer nofilereferer nolist nolog nopause
		noprint noredir noreferer nosocks nostatus number_links
		popup post_data print pseudo_inlines raw realm reload
		restrictions resubmit_posts rlogin selective show_cursor
		source startfile_ok telnet term trace traversal underscore
		validate version vikeys)' \
        -- lynx
#------------------------------------------------------------------------------
# ssh (secure shell)
compctl -k hosts \
	-x "c[-1,-l]" -u \
	- "c[-1,-i]" -f \
	- "c[-1,-e]" -k "(~ none)" \
	- "c[-1,-c]" -k "(idea des 3des tss arcfour none)" \
	- "c[-1,-p]" -k ports \
	- "c[-1,-L] c[-1,-R] c[-1,-o]" -k "()" \
	-- ssh
#------------------------------------------------------------------------------
# network stuff
compctl -k hosts \
	-x "s[-class=]" -k "(any in chaos hesiod)" \
	- "s[-query=]" -k "(a cname hinfo md mx mb mg minfo ns ptr soa txt uinfo wks any)" \
	- "s[-]" -Q -S '' -k "(query= all\  class= d2\  nod2\  debug\  nodebug\  defname\  nodefname\  domain= ignoretc\  noignoretc\ )" \
	-- nslookup

compctl -k hosts \
	-x "C[-1,[^-]*] p[2,-1]" -k ports \
	-- telnet

compctl -x 'N[-1,@]' -k hosts - 's[]' -u -qS '@' -- finger
#------------------------------------------------------------------------------
# gdb
compctl -/g "*(*)" \
	-x "s[-]" -k "(help nx q batch cd f b tty exec se core symbols c x d)" \
	- "C[-1,(-cd|-directory)]" -/ \
	- "C[-1,(-core|-c)]" -/g 'core*' \
	- "C[-1,(-se|-exec)]" -f \
	- "C[-1,(-symbols|-command|-x)]" -f \
	- "p[2,-1] C[-1,[^-]*]" -/g "*core" \
	-- gdb
#############################################################################
# Dpkg completion control for zsh.
#
# NOTE: These commands (dpkg, dpkg-source, bug) are included
# upstream as part of the new completion system.  Consider
# using that instead.
#
# Originally by Joey Hess <joey@kite.ml.org>, GPL copyright.
# Contributions and fixes from Karl Hegbloom, Fabien Ninoles,
# Gregor Hoffleit, Csaba Benedek, &c.
#
# Currently doesn't handle correctly:
#       Options after -D or --debug.
#       --force- and friends,--ignore-depends,--root= and friends.

# A function to return all available package names.
function DpkgPackages {
        reply=(`egrep ^Package: /var/lib/dpkg/status | awk '{ print $2 }'`)
}

# This array lists all the dpkg options and actions.
dpkg_options=(-i --install --unpack --configure -r --remove --purge -A \
--avail --update-avail --merge-avail --yet-to-unpack -l --list -L \
--listfiles -C --audit -S --search -s --status --help -c --contents -I \
--info -B --auto-deconfigure -D --debug --largemem --smallmem --no-act \
-R --recursive -G -O --selected-only -E -e --control --skip-same-version \
-x --extract -f --field --fsys-tarfile -X --vextract --licence --version \
-b --build)

# This string lists all dpkg actions that operate on *.deb files, 
# separated by |'s. There can't be any extra whitespace in it!
dpkg_deb_actions="-i|--install|--unpack|-A|--avail|-c|--contents|-I|--info|-e"
dpkg_deb_actions="$dpkg_deb_actions|--control|-x|--extract|-f|--field"
dpkg_deb_actions="$dpkg_deb_actions|--fsys-tarfile|-X|--vextract|-info"

# This string lists all dpkg actions that normally operate on *.deb files,
# but can operate on directory names if the --recursive option is given to 
# dpkg.
dpkg_deb_rec_actions="-i|--install|--unpack|-A|--avail"

# This string lists all other dpkg actions that take a directory name as 
# their first parameter, and a filename as their second parameter.
dpkg_df_actions="-b|--build"

# This string lists dpkg actions that take a directory name as 
# their second parameter.
dpkg_dir2_actions="-e|--control|-x|--extract|--vextract"

# This string lists all dpkg actions that take a filename as their first
# parameter (ie, a Packages file).
dpkg_file_actions="-S|--search|--update-avail|--merge-avail"

# This string lists all dpkg actions that operate on the names of packages
# and can also be used with the --pending option.
dpkg_pkg_pending_actions="--configure|-r|--remove|--purge|-s|--status"

# This string lists all other dpkg actions that operate on the names of 
# packages.
dpkg_pkg_actions="-L|--listfiles|-s|--status|-l|--list"

# Now the command that puts it all together..
compctl -k dpkg_options \
  -x "C[-1,$dpkg_deb_rec_actions],R[-R|--recursive,]" -g '*(-/D)' \
  - "C[-1,$dpkg_deb_actions]" -g '*.deb' + -g '*(-/D)' \
  - "C[-1,$dpkg_pkg_pending_actions]" -K DpkgPackages + -k "(-a,--pending)" \
  - "C[-1,$dpkg_pkg_actions]" -K DpkgPackages \
  - "C[-1,$dpkg_file_actions],C[-2,$dpkg_df_actions]" -f \
  - "C[-2,$dpkg_dir2_actions],C[-1,$dpkg_df_actions]" -g '*(-/D)' \
  -- dpkg

# Also, set up package name completion for bug program.
compctl -K DpkgPackages bug

# This section by Karl M. Hegbloom

dpkg_source_options=(-x -b -c -l -F -V -T -D -U \
-sa -sk -sp -su -sr -ss -sn -sA -sK -sP -sU -sR \
-h --help)

compctl -k dpkg_source_options \
 -x "C[-1,-x]" -g '*.dsc' \
 - "C[-1,-b]" -g '*(-/D)' \
 -- dpkg-source

# Unset the temporary variables.
unset dpkg_deb_actions dpkg_deb_rec_actions dpkg_df_actions \
        dpkg_dir2_actions dpkg_file_actions dpkg_pkg_pending_actions \
        dpkg_pkg_actions # dpkg_source_options dpkg_options

#############################################################################
