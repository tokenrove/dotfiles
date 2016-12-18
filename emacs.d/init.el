;;;; assembled by magpies

(setq debug-on-error t
      debug-on-quit t)

(eval-when-compile (require 'cl))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
 (require 'use-package))
(setq use-package-verbose t
      use-package-always-ensure t)
(require 'bind-key)

(let ((debian-startup "/usr/share/emacs/site-lisp/debian-startup.el"))
  (when (file-exists-p debian-startup)
    (load-file debian-startup)
    (debian-startup 'emacs)))


;;;; LOOK & FEEL

;; also set in Xdefaults, but it never hurts to be sure.
(set-default-font "Inconsolata 18")

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


;;;; MODELINE

(use-package delight)

(require 'uniquify)
(eval-after-load "uniquify"
  '(setq uniquify-buffer-name-style 'forward))

;;; something minimal
(let ((rhs " %l"))
  (setq-default
   mode-line-format
   (list
    '(:eval (propertize " %b"
             'face (if (buffer-modified-p)
                       'font-lock-warning-face
                       'font-lock-keyword-face)))
    `(:eval (propertize ,rhs
             'display `((space :align-to (- (+ right right-fringe right-margin)
                                            ,(length (format-mode-line ,rhs))))))))))
;;; idea from https://github.com/dandavison/minimal
(unless (facep 'minimal-mode-line-inactive)
  (copy-face 'mode-line-inactive 'minimal-mode-line-inactive))
(set-face-attribute 'minimal-mode-line-inactive nil
                    :background "dim grey"
                    :height 0.1)
(setq face-remapping-alist
      (cons '(mode-line-inactive minimal-mode-line-inactive)
            (assq-delete-all 'mode-line-inactive face-remapping-alist)))


;;;; Random important emacs customizations

(show-paren-mode t)                     ; highlight parenthesis matches.
(setq-default font-lock-auto-fontify t) ; always do syntax highlighting.
(global-font-lock-mode t)               ;   really.
(setq-default show-trailing-whitespace t)
(setq font-lock-verbose nil
      default-major-mode 'text-mode     ; If you don't know, just give me text-mode
      comment-style 'extra-line)        ; nice comment format
(put 'narrow-to-region 'disabled nil)   ; don't bitch at me for using ^Xnn
(put 'downcase-region 'disabled nil)
(set-fill-column 74)                    ; not quite standard.
(delete-selection-mode -1)
(set-language-environment "UTF-8")      ; anything ken invented must be good.
(prefer-coding-system 'utf-8)           ;   ditto.
(setq-default indent-tabs-mode nil)     ; tabs suck.
(setq make-backup-files nil)             ; herecy, I know.

;;; XXX I should disable this on Windows where it makes things really
;;; slow.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

(random t)                              ; Do random numbers

(use-package ido
  :config
  (setq ido-use-filename-at-point 'guess
        ido-enable-flex-matching t)
  (ido-mode 1)
  (ido-everywhere 1))
(use-package flx-ido :config (flx-ido-mode t))
(use-package ido-ubiquitous :config (ido-ubiquitous-mode 1))
(use-package smex)
(use-package idomenu)

(setq reb-re-syntax 'string)            ; regexp-builder

(use-package color-identifiers-mode
  :config
  (color-identifiers-mode t)
  (delight 'color-identifiers-mode))

(use-package hl-line
  :config (global-hl-line-mode t))

(use-package ws-butler
  :config (ws-butler-global-mode t))

(defun text-mode-nicities ()
  (auto-fill-mode)			; wrap lines and so on.
  ;;(footnote-mode)			; see [1] and so on.
  )
(add-hook 'text-mode-hook 'text-mode-nicities)
(add-hook 'message-mode-hook 'text-mode-nicities)

(eval-after-load 'dired '(load-file "~/.emacs.d/init-dired.el"))

(use-package midnight)

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (delight 'undo-tree-mode))

(use-package saveplace
  :config (save-place-mode t))

;; M-/ completes using hippie-expand, which mostly uses dabbrev, i.e. just
;; finds any matching text in open buffers.
(require 'dabbrev)
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

;; (use-package rainbow-delimiters
;;   :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(auto-compression-mode 1)   ; transparently work with compressed files

(setq-default
 tab-always-indent 'complete
 dabbrev-case-replace t                ; match case with M-/
 font-lock-maximum-decoration t
 even-window-heights nil               ; I don't like emacs destroying my window setup
 resize-mini-windows nil
 cursor-in-non-selected-windows nil    ; Don't show a cursor in other windows
 display-time-24hr-format t            ; No am/pm here
 default-tab-width 8                   ; A tab is 8 spaces is 8 spaces is 8 spaces
 scroll-preserve-screen-position 'keep ; Scrolling is moving the document, not moving my eyes
 inhibit-startup-message t             ; we know where we are.
 x-stretch-cursor t                    ; A wide characters ask for a wide cursor
 x-select-enable-clipboard t
 select-enable-clipboard t
 x-select-enable-primary t
 select-enable-primary t
 save-interprogram-paste-before-kill t
 apropos-do-all t
 mouse-yank-at-point t ; I want a mouse yank to be inserted where the point is, not where i click
 mouse-highlight 1 ; Don't highlight stuff that I can click on all the time. I don't click anyways.
 visible-bell t)                       ; Beeps suck
(blink-cursor-mode -1)                  ; less wakeups: save power.
(mouse-avoidance-mode 'banish)          ; get the rodent out of my way.

(use-package whitespace
  :config
  (setq-default
   whitespace-style '(face tabs lines-tail trailing indentation)
   whitespace-line-column 80)
  (global-whitespace-mode t))


;;;; KEY BINDINGS

(bind-keys
 ("M-/"      . hippie-expand)
 ("C-x C-b"  . ibuffer)
 ("C-s"      . isearch-forward-regexp)
 ("C-r"      . isearch-backward-regexp)
 ("C-M-s"    . isearch-forward)
 ("C-c r"    . recompile)
 ("<F9>"     . recompile)
 ("M-j"      . (lambda () (interactive) (join-line -1)))
 ("C-|"      . move-to-column)                 ; Almost vi-ish.
 ("C-x %"    . toggle-read-only)
 ("C-x \\"   . align-regexp))

(bind-keys*                    ; * => don't let anyone override these.
 ("M-x" . smex)
 ;; Dvorak bindings.
 ("C-." . smex)
 ("C-," . Control-X-prefix)
 ("C-'" . hippie-expand))

;; Activate occur easily inside isearch
(bind-key "C-o"
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))
  isearch-mode-map)


;;;; PROGRAMMING LANGUAGES

(use-package slime
  :config
  (slime-setup '(slime-fancy slime-asdf slime-banner slime-autodoc
                 slime-editing-commands slime-references slime-indentation))
  (setq slime-complete-symbol*-fancy t
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol
        slime-repl-history-remove-duplicates t
        slime-repl-history-trim-whitespace t
        slime-lisp-implementations
        `((sbcl ("sbcl") :coding-system utf-8-unix)
          (ccl ("ccl") :coding-system utf-8-unix)
          (clisp ("clisp"))
          (ecl ("ecl")))
        slime-net-coding-system 'utf-8-unix
        slime-default-lisp 'sbcl))

(use-package ponylang-mode
  :config
  (add-hook
   'ponylang-mode-hook
   (lambda ()
     (set-variable 'indent-tabs-mode nil)
     (set-variable 'tab-width 2))))

;; handle colored output in compilation mode
(use-package ansi-color
  :config
  (add-hook 'compilation-filter-hook
            (lambda ()
              (when (eq major-mode 'compilation-mode)
                (ansi-color-apply-on-region compilation-filter-start (point-max))))))

(require 'cc-mode)

(use-package semantic
  :config
  (global-semanticdb-minor-mode 1)
  (global-semantic-idle-scheduler-mode 1)
  (add-hook 'prog-mode-hook #'semantic-mode))

(use-package paredit
  :bind (:lisp-interaction-mode-map ("S-return" . eval-print-last-sexp))
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode))

(use-package flycheck
  :config
  (global-flycheck-mode 1)
  (setq flycheck-check-syntax-automatically '(mode-enabled save)))

(use-package flycheck-color-mode-line
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-color-mode-line-mode))

(setq compilation-scroll-output 'first-error)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(add-to-list 'load-path "~/src/elisp/")

(load-file "~/.emacs.d/init-c.el")

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(use-package csharp-mode
  :mode "\\.cs$"
  :config (add-hook 'csharp-mode-hook (lambda () (local-set-key "{" 'c-electric-brace))))

(use-package fsharp-mode
  :commands (fsharp-mode run-fsharp)
  :mode "\\.fs[iylx]?$"
  :config
  (setq inferior-fsharp-program "fsi --readline-"
        fsharp-compiler "fsc"))

(use-package cperl-mode
  :init
  (defalias 'perl-mode 'cperl-mode)
  :config
  (setq cperl-hairy t))

;; (use-package lilypond-mode
;;   :load-path "/usr/local/"
;;   :config (setq LilyPond-pdf-command "zathura"))

(use-package j-mode
  :config (setq j-console-cmd "ijconsole"))

(use-package erlang)
(use-package flycheck-rebar3
  :config (flycheck-rebar3-setup))

(use-package geiser)

(use-package elisp-slime-nav
  :config (add-hook 'emacs-lisp-mode-hook #'elisp-slime-nav-mode))

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

;; (use-package python-pylint)
;; (use-package python-pep8)
;; (use-package pysmell-autoloads)
;; (use-package python-mode
;;   :config
;;   (progn
;;     (add-hook 'python-mode-hook (lambda () (pysmell-mode 1)))
;;     (setq python-remove-cwd-from-path nil)))

(use-package glsl-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.vert$" . glsl-mode))
  (add-to-list 'auto-mode-alist '("\\.frag$" . glsl-mode)))

(use-package magit
  :bind (("\C-ci" . magit-status))
  :config
  (setq magit-save-repository-buffers nil
        magit-completing-read-function 'magit-ido-completing-read)
  (defadvice magit-status (around magit-fullscreen activate)
    "full screen magit-status"
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defadvice magit-mode-quit-window (around magit-restore-screen activate)
    ad-do-it
    (jump-to-register :magit-fullscreen)))

(autoload 'typing-of-emacs "typing" "The Typing Of Emacs, a game." t)

(require 'tempbuf)
(dolist (m '("dired" "custom" "Man" "view"))
  (add-hook (intern (concat m "-mode-hook"))
            #'turn-on-tempbuf-mode))

(use-package org
  :config
  (eval-after-load 'org '(load-file "~/.emacs.d/init-org.el")))

(defvar libnotify-program "/usr/bin/notify-send")
(defun notify-send (title message)
  (start-process "notify" " notify"
                 libnotify-program "--expire-time=4000" title message))

(autoload 'griffin "griffin" "Compile static blog" t)


;;;; finally...

(server-start)

(setq debug-on-error nil
      debug-on-quit nil)
