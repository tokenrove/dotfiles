set nocompatible
syntax on
set autoindent
set shiftwidth=4
set softtabstop=4
set textwidth=72
set wildmode=full
set modelines=5
set expandtab
"set hidden
set laststatus=2
set lazyredraw
set wmnu
set showmatch
set visualbell
"set guifont=-artwiz-runt-medium-r-normal-*-*-100-*-*-m-*-iso10646-1
"set guifont=Courier\ 11
set guifont=Monospace\ 10
set guioptions=agi
filetype indent on

" Fold movement binds
nmap <C-H> za
nmap <NL> zj
nmap <C-K> zk

"set foldmethod=syntax

color tekblue

augroup filetypedetect
au BufNewFile,BufRead *.nw      setf noweb
au BufNewFile,BufRead *.nws     setf nowebasm
au BufNewFile,BufRead *.nw6     setf noweb6502asm
au BufNewFile,BufRead TODO      setf todo
au BufNewFile,BufRead Jamfile	setf jam
au BufNewFile,BufRead Jamrules	setf jam
au BufNewFile,BufRead *.wart    setf wart
au BufNewFile,BufRead *.ly      setf lilypond
au BufNewFile,BufRead *.lisp    set ai lisp
au BufNewFile,BufRead *.cl      set ai lisp
augroup END

if has("autocmd")

" Support editing of gpg-encrypted files
augroup gnupg
	" Remove all gnupg autocommands
	au!

	
	" Enable editing of gpg-encrypted files
	"			 read: set binary mode before reading the file
	"						 decrypt text in buffer after reading
	"			write: encrypt file after writing
	"		 append: decrypt file, append, encrypt file
	autocmd BufReadPre,FileReadPre      *.gpg set bin
	autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
	autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg -d 2>/dev/null
	autocmd BufReadPost,FileReadPost    *.gpg set nobin
	autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
	autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
	autocmd BufReadPost,FileReadPost    *.gpg set tw=78

	autocmd BufWritePost,FileWritePost  *.gpg !mv <afile> <afile>:r
	autocmd BufWritePost,FileWritePost  *.gpg !gpg -e <afile>:r
	autocmd BufWritePost,FileWritePost  *.gpg !rm <afile>:r

	autocmd FileAppendPre               *.gpg !gpg -d 2>/dev/null <afile>
	autocmd FileAppendPre               *.gpg !mv <afile>:r <afile>
	autocmd FileAppendPost              *.gpg !mv <afile> <afile>:r
	autocmd FileAppendPost              *.gpg !gpg -e <afile>:r
	autocmd FileAppendPost              *.gpg !rm <afile>:r

	" Same as above, but for ASCII-armored files
	autocmd BufReadPre,FileReadPre      *.asc set bin
	autocmd BufReadPre,FileReadPre      *.asc let ch_save = &ch|set ch=2
	autocmd BufReadPost,FileReadPost    *.asc '[,']!gpg -d 2>/dev/null
	autocmd BufReadPost,FileReadPost    *.asc set nobin
	autocmd BufReadPost,FileReadPost    *.asc let &ch = ch_save|unlet ch_save
	autocmd BufReadPost,FileReadPost    *.asc execute ":doautocmd BufReadPost " . expand("%:r")

	autocmd BufWritePost,FileWritePost  *.asc !mv <afile> <afile>:r
	autocmd BufWritePost,FileWritePost  *.asc !gpg -a -e <afile>:r
	autocmd BufWritePost,FileWritePost  *.asc !rm <afile>:r

	autocmd FileAppendPre               *.asc !gpg -d 2>/dev/null <afile>
	autocmd FileAppendPre               *.asc !mv <afile>:r <afile>
	autocmd FileAppendPost              *.asc !mv <afile> <afile>:r
	autocmd FileAppendPost              *.asc !gpg -a -e <afile>:r
	autocmd FileAppendPost              *.asc !rm <afile>:r
augroup END

endif
 
map <F9> :noh<CR>

" EOF
