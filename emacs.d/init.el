;;;;
;;; emacs configuration
;;; Julian Squires <julian@cipht.net> / 2003-2007
;;;
;;; Things here were stolen from:
;;;    bdowning
;;;    Sascha Chua
;;;    Forcer
;;;    and others

;;;; Stuff that will be used later in this script.

(eval-when-compile
  (require 'cl))

(require 'tramp)
(defvar hostname (intern tramp-default-host))

(when (featurep 'aquamacs)
  (load "init-aquamacs.el"))

;;; totally stolen from http://www.mygooglest.com/fni/dot-emacs.html
;;; although perhaps all I really need is (require 'foo nil t)
(defvar missing-packages-list nil
  "List of packages that `try-require' can't find.")

;; attempt to load a feature/library, failing silently
(defun js/try-require (feature)
  (unless (require feature nil t)
    (push feature missing-packages-list)
    (message "Missing `%s'" feature)))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(add-to-list 'load-path "~/src/elisp/")
(add-to-list 'load-path "/usr/local/lilypond/usr/share/emacs/site-lisp/")

(eval-after-load "gnus"
  '(setq gnus-init-file "~/.emacs.d/gnus.el"))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;; ELPA / PACKAGE.EL
;;; This was installed by package-install.el.
;; (when (load (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;; XXX: IDEA: defadvice around package-list-packages that asks what
;;; you intended to look for before display the list, since I so
;;; frequently get distracted by the new packages and forget what I
;;; was going to do.

(defvar my-packages
  (mapcar #'read
          (with-temp-buffer
            (insert-file-contents "~/dotfiles/emacs-packages")
            (split-string (buffer-string) "\n" t))))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;;; ?

;;(set-default-font "-xos4-terminus-medium-r-normal--16-160-72-72-c-80-iso10646-1")
;; (set-frame-font "Inconsolata 14")       ; done in .Xdefaults now

;; (require 'auto-compile)
;; (auto-compile-on-save-mode)

;;;; Random important emacs customizations

(show-paren-mode t)                     ; highlight parenthesis matches.
(setq-default font-lock-auto-fontify t) ; always do syntax highlighting.
(global-font-lock-mode t)               ;   really.
(setq font-lock-verbose nil)
(put 'narrow-to-region 'disabled nil)   ; don't bitch at me for using ^Xnn
(put 'downcase-region 'disabled nil)
(column-number-mode t)                  ; show column numbers
(set-fill-column 74)                    ; not quite standard.
(delete-selection-mode -1)
(setq backup-by-copying-when-linked t	; don't fuck over hardlinked files.
      backup-by-copying-when-mismatch t) ; careful with ownership
(mouse-avoidance-mode 'banish)          ; get the rodent out of my way.
(set-language-environment "UTF-8")	; anything ken invented must be good.
(prefer-coding-system 'utf-8)           ;   ditto.
(setq-default indent-tabs-mode nil)     ; tabs suck.
(ido-mode t)
(blink-cursor-mode -1)			; less wakeups: save power.
(electric-pair-mode -1)			; gets annoying fast.

(ido-ubiquitous-mode t)
(flx-ido-mode t)

(icomplete-mode t)
(setq reb-re-syntax 'string)

(require 'color-identifiers-mode)
(color-identifiers-mode t)
(global-hl-line-mode t)                 ; try this for a while.

(ws-butler-global-mode t)

(defun text-mode-nicities ()
  (auto-fill-mode)			; wrap lines and so on.
  ;;(footnote-mode)			; see [1] and so on.
  )
(add-hook 'text-mode-hook 'text-mode-nicities)
(add-hook 'message-mode-hook 'text-mode-nicities)

;;; XXX I should disable this on Windows where it makes things really
;;; slow.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))

(eval-after-load 'dired '(load-file "~/.emacs.d/init-dired.el"))

(require 'midnight)
(require 'undo-tree)

(global-undo-tree-mode 1)

;; great ideas from better-defaults
(require 'saveplace)
(setq-default save-place t)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
;;(global-set-key (kbd "C-M-r") 'isearch-backward)

(global-set-key (kbd "C-c r") 'recompile)


;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

(js/try-require 'rainbow-delimiters)

;;; Stolen from forcer's .emacs

(auto-compression-mode 1)   ; transparently work with compressed files

(setq-default
 font-lock-maximum-decoration t
 default-major-mode 'text-mode         ; If you don't know, just give me text-mode
 even-window-heights nil               ; I don't like emacs destroying my window setup
 resize-mini-windows nil
 cursor-in-non-selected-windows nil    ; Don't show a cursor in other windows
 display-time-24hr-format t            ; No am/pm here
 default-tab-width 8                   ; A tab is 8 spaces is 8 spaces is 8 spaces
 scroll-preserve-screen-position 'keep ; Scrolling is moving the document, not moving my eyes
 inhibit-startup-message t             ; we know where we are.
 comment-style 'extra-line             ; nice comment format
 x-stretch-cursor t                    ; A wide characters ask for a wide cursor
 x-select-enable-clipboard t
 select-enable-clipboard t
 x-select-enable-primary t
 select-enable-primary t
 save-interprogram-paste-before-kill t
 apropos-do-all t
 mouse-yank-at-point t ; I want a mouse yank to be inserted where the point is, not where i click
 save-place-file (concat user-emacs-directory "places")
 mouse-highlight 1 ; Don't highlight stuff that I can click on all the time. I don't click anyways.
 visible-bell t)                       ; Beeps suck

(require 'whitespace)
(setq whitespace-style '(face tabs lines-tail trailing))
(global-whitespace-mode t)

;;; Backup files

;; I've changed my mind about backup files.  They really aren't so
;; useful now that I try to version the world.

(setq make-backup-files nil)             ; herecy, I know.

;; ;; Put them in one nice place if possible
;; (setq backup-by-copying t    ; Don't delink hardlinks
;;       delete-old-versions t  ; Clean up the backups
;;       version-control t      ; Use version numbers on backups,
;;       kept-new-versions 3    ; keep some new versions
;;       kept-old-versions 2)   ; and some old ones, too

;;(transient-mark-mode) ; Show the region by default
(setq mark-even-if-inactive t)     ; But don't bitch if it's not shown

(random t)                              ; Do random numbers

;;(require 'sr-speedbar)
;;(global-set-key [?\C-\;] 'sr-speedbar-toggle)

;;;; BINDINGS
;; some random key bindings
(global-set-key [?\M-S] 'goto-line)     ; old xemacs habits die hard, but
                                        ; M-g was taken.
(global-set-key [?\C-|] 'move-to-column) ; Almost vi-ish.
(global-set-key [?\C-x ?%] 'toggle-read-only)
(global-set-key [?\C-c ?\C-f] 'find-file-at-point)
(global-set-key [?\C-x ?\\] 'align-regexp)

;; Dvorak bindings.
(global-set-key [?\C-.] 'smex)
(global-set-key [?\C-,] (lookup-key global-map [?\C-x]))
(global-set-key [?\C-'] 'hippie-expand)

(global-set-key [?\M-x] 'smex)

(setq tab-always-indent 'complete)
;; M-/ completes using hippie-expand, which mostly uses dabbrev, i.e. just
;; finds any matching text in open buffers.
(setq hippie-expand-try-functions-list
  '(try-complete-file-name-partially
    try-complete-file-name
    try-expand-all-abbrevs
    try-expand-dabbrev
    try-expand-dabbrev-visible
    try-expand-dabbrev-all-buffers
    try-expand-dabbrev-from-kill
    try-complete-lisp-symbol-partially
    try-complete-lisp-symbol))

(require 'dabbrev)
(setq dabbrev-case-replace t)         ; match case with M-/

;;;; LISPY LISPY LISP

;; Prompt before evaluating local bits of lisp.  This stops people
;; putting things at the end of files which delete all your files!
(setq enable-local-variables t
      enable-local-eval      1)

;;; diary/calendar

(display-time)
;;(add-hook 'diary-hook 'appt-make-list)
;;(diary 0)

;;;; CUTENESS

(require 'uniquify)
(eval-after-load "uniquify"
  '(setq uniquify-buffer-name-style 'forward))

;; kill the damn tool/menu/scrollbars.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;;(load-theme 'tronesque t)
;; (load-theme 'mbo70s t)
(load-theme 'sanityinc-tomorrow-day t)
;; (let ((fav-light-themes (sanityinc-tomorrow-day sanityinc-solarized-light))
;;       (fav-dark-themes (mbo70s sanityinc-tomorrow-eighties tronesque))))

(setq display-time-24hr-format t
      calendar-latitude 45.5
      calendar-longitude -73.56)

(require 'powerline)

(defun js-powerline-theme ()
  "Setup the mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          powerline-default-separator
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           powerline-default-separator
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list (powerline-raw "%*" nil 'l)
                                     (powerline-buffer-size nil 'l)
                                     (powerline-raw mode-line-mule-info nil 'l)
                                     (powerline-buffer-id nil 'l)
                                     (when (and (boundp 'which-func-mode) which-func-mode)
                                       (powerline-raw which-func-format nil 'l))
                                     (powerline-raw " ")
                                     (funcall separator-left mode-line face1)
                                     (when (boundp 'erc-modified-channels-object)
                                       (powerline-raw erc-modified-channels-object face1 'l))
                                     (powerline-major-mode face1 'l)
                                     (powerline-process face1)
                                     (powerline-minor-modes face1 'l)
                                     (powerline-narrow face1 'l)
                                     (powerline-raw " " face1)
                                     (funcall separator-left face1 face2)
                                     (powerline-vc face2 'r)))
                          (rhs (list (powerline-raw global-mode-string face2 'r)
                                     (funcall separator-right face2 face1)
                                     (powerline-raw "%4l" face1 'l)
                                     (powerline-raw ":" face1 'l)
                                     (powerline-raw "%3c" face1 'r)
                                     (powerline-hud face2 face1))))
                     (concat (powerline-render lhs)
                             (powerline-fill face2 (powerline-width rhs))
                             (powerline-render rhs)))))))

(js-powerline-theme)

;;;; SLIME STUFF
(require 'slime-autoloads)
(setq slime-contribs '(slime-fancy slime-asdf slime-banner slime-autodoc
                       slime-editing-commands slime-references slime-indentation))
(slime-setup '(slime-fancy slime-asdf slime-banner slime-autodoc
               slime-editing-commands slime-references slime-indentation))
(eval-after-load "slime"
  '(progn
    (setq slime-complete-symbol*-fancy t
          slime-complete-symbol-function 'slime-fuzzy-complete-symbol
          slime-repl-history-remove-duplicates t
          slime-repl-history-trim-whitespace t)

    ;; ;; special indentation
    ;; (mapcar #'define-cl-indent
    ;; 	    ;; indentation for SERIES forms
    ;; 	    '((iterate  . let)
    ;; 	      (mapping . let)
    ;; 	      (producing ((&whole 4 &rest 1) (&whole 4 &rest 1) &rest 2))
    ;; 	      ;; indentation for ANAPHORA forms
    ;; 	      (asif . if)
    ;; 	      ;; indentation for assembler forms
    ;; 	      (assemble . tagbody)))))
    (add-hook 'slime-mode-hook
              (lambda ()
                (set-variable lisp-indent-function 'common-lisp-indent-function)))
    (setq slime-lisp-implementations
          `((sbcl ("sbcl") :coding-system utf-8-unix)
            (ccl ("ccl") :coding-system utf-8-unix)
            (clisp ("clisp"))
            (ecl ("ecl")))
          slime-net-coding-system 'utf-8-unix
          slime-default-lisp 'sbcl)))

;;;; PROGRAMMING LANGUAGES

(global-set-key (kbd "<f9>") 'recompile)

;; handle colored output in compilation mode
(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)

(add-hook 'prog-mode-hook
          (lambda ()
            (rainbow-delimiters-mode)
            (setq show-trailing-whitespace t)
            (color-identifiers-mode)))
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (elisp-slime-nav-mode)
            (paredit-mode)))
(add-hook 'lisp-mode-hook
          (lambda ()
            (paredit-mode)))

(define-key lisp-interaction-mode-map [S-return] 'eval-print-last-sexp)

;;; Flycheck
(require 'flycheck)
;; (global-flycheck-mode)
(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
(setq flycheck-check-syntax-automatically '(mode-enabled save))

(setq compilation-scroll-output 'first-error)

;;; C / C++ / etc

(load-file "~/.emacs.d/init-c.el")

;;; Java bullshit
;;(js/try-require 'jde)

(when (eql hostname 'graphite)
  (load-file "/usr/share/emacs/site-lisp/debian-startup.el")
  (debian-startup 'emacs24))

;;; markdown

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
(autoload 'textile-mode "textile-mode.el" "Major mode for editing Textile files" t)
(setq auto-mode-alist (cons '("\\.textile" . textile-mode) auto-mode-alist))

;;; C#

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
(add-hook 'csharp-mode-hook (lambda () (local-set-key "{" 'c-electric-brace)))

;;; F#

(add-to-list 'load-path "~/.emacs.d/site-lisp/fsharp/")
(autoload 'fsharp-mode "fsharp-mode" "Major mode for editing F# code." t)
(autoload 'run-fsharp "inf-fsharp" "Run an inferior F# process." t)
(setq auto-mode-alist (append '(("\\.fs[iylx]?$" . fsharp-mode)) auto-mode-alist))
(eval-after-load "fsharp-mode"
  '(progn
     (setq inferior-fsharp-program "~/bin/fsi --readline-")
     (setq fsharp-compiler "~/bin/fsc")))

;;; Tcl/Tk

(autoload 'tcl-mode "tcl")
(autoload 'inferior-tcl "tcl")
(eval-after-load "tcl-mode"
  '(setq tcl-application "wish8.5"))

;;; PERL

(require 'cperl-mode)
(defalias 'perl-mode 'cperl-mode)
(setq cperl-hairy t)

;;; Lilypond

(eval-after-load "lilypond-mode"
  '(setq LilyPond-pdf-command "zathura"))

;;; haXe / Flash

(autoload 'haxe-mode "haxe-mode.el"  "Major mode for haXe." t)
(setq auto-mode-alist (cons '("\\.hx" . haxe-mode) auto-mode-alist))

;;; J stuff
(autoload 'j-mode "j-mode.el"  "Major mode for J." t)
(autoload 'j-shell "j-mode.el" "Run J from emacs." t)
(setq auto-mode-alist (cons '("\\.ij[rstp]" . j-mode) auto-mode-alist))
(eval-after-load "j-mode"
  '(setq j-path "/home/julian/lib/j64-701"
	j-command "/home/julian/lib/j64-701/bin/jconsole"
	;;      j-command-args nli
	j-dictionary-url "file:///home/julian/lib/j64-701/addons/help"))

;;; golang

(js/try-require 'go-mode-load)


;;; erlang
(js/try-require 'erlang-start)
(add-to-list 'load-path "~/build/lfe/emacs/")
(js/try-require 'lfe-start)
(js/try-require 'edts-start)

;;; scheme
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/geiser/build/elisp")
;; (js/try-require 'geiser-install)

(js/try-require 'elisp-slime-nav)

;;; ocaml

;; XXX TODO rebind merlin C-c C-l and C-c & to M-. and M-,

;; Seriously, why are you messing with my keys?
(add-hook 'tuareg-mode-hook
          (lambda ()
            (define-key tuareg-mode-map "\C-ci" 'magit-status)
            (define-key tuareg-mode-map "\C-c\C-z" 'utop)))

(setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

(require 'ocp-indent)
(require 'merlin)
;; Start merlin on ocaml files
(add-hook 'tuareg-mode-hook 'merlin-mode t)
(add-hook 'caml-mode-hook 'merlin-mode t)
;; Enable auto-complete
(setq merlin-use-auto-complete-mode 'easy)
;; Use opam switch to lookup ocamlmerlin binary
(setq merlin-command 'opam)

;; Setup environment variables using opam
(dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
  (setenv (car var) (cadr var)))

;; Update the emacs path
(setq exec-path (append (parse-colon-path (getenv "PATH"))
                        (list exec-directory)))

;; Update the emacs load path
(add-to-list 'load-path (expand-file-name "../../share/emacs/site-lisp"
                                          (getenv "OCAML_TOPLEVEL_PATH")))

;; Automatically load utop.el
(autoload 'utop "utop" "Toplevel for OCaml" t)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)

;;; Python
(js/try-require 'python-pylint)
(js/try-require 'python-pep8)
(js/try-require 'pysmell-autoloads)
(eval-after-load "python-mode"
  '(progn
     (add-hook 'python-mode-hook (lambda () (pysmell-mode 1)))
     (setq python-remove-cwd-from-path nil)))

;;; ASSEMBLER

(add-to-list 'auto-mode-alist '("\\.[sS]$" . asm-mode))

;;; HASKELL

;;; XML

(autoload 'rnc-mode "rnc-mode" "RELAX NG mode" t)
(add-to-list 'auto-mode-alist '("\\.rng$" . rnc-mode))

;;; WEB

;;; GL

(autoload 'glsl-mode "glsl-mode" "GLSL mode" t)
(add-to-list 'auto-mode-alist '("\\.vert$" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag$" . glsl-mode))

;;;; CHM files (experimental)

;; (add-to-list 'load-path "~/src/chm-mode/")
;; ;; (js/try-require 'chm-mode)
;; ;; (js/try-require 'view-chm)
;; (autoload 'view-chm-in-w3m "view-chm" "CHM browser" t)
;; (add-to-list 'auto-mode-alist '("\\.chm$" . view-chm-in-w3m))


;;;; magit

(autoload 'magit-status "magit" nil t)
(global-set-key "\C-ci" 'magit-status)

(setq magit-save-repository-buffers nil)

;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defadvice magit-mode-quit-window (around magit-restore-screen activate)
  ad-do-it
  (jump-to-register :magit-fullscreen))

;;;; EMAIL / NEWS

(load-file "~/.emacs.d/init-mail.el")

;;;; RANDOM PACKAGES
(autoload 'typing-of-emacs "typing" "The Typing Of Emacs, a game." t)

(require 'tempbuf)
(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'custom-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'Man-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'view-mode-hook 'turn-on-tempbuf-mode)

;;;; ORG MODE
(require 'org)
(eval-after-load 'org '(load-file "~/.emacs.d/init-org.el"))

;;;; JABBER

(eval-after-load "jabber"
  '(setq jabber-history-enabled t
        jabber-use-global-history nil
        jabber-backlog-number 40
        jabber-backlog-days 30
        jabber-auto-reconnect t
        jabber-keepalive-interval 180
        password-cache-expiry nil
        jabber-account-list '(("julian.squires@gmail.com"
			     (:network-server . "talk.google.com")
			     (:port . 5223)
			     (:connection-type . ssl)))))

(defvar libnotify-program "/usr/bin/notify-send")

(defun notify-send (title message)
  (start-process "notify" " notify"
		 libnotify-program "--expire-time=4000" title message))

;;;; MISCELLANEOUS

(autoload 'griffin "griffin" "Compile static blog" t)

;; (require 'full-ack)
;; (setq ack-executable "/usr/bin/ack-grep")

;; (require 'fixmee)
;; (global-fixmee-mode 1)

(server-start)

;;; mpd / emms

;;(load-file "~/.emacs.d/init-emms.el")


;;;; DIMINISH

(require 'delight)
(delight 'auto-complete-mode)
(delight 'color-identifiers-mode)
(delight 'undo-tree-mode)
