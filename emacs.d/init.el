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
(set-frame-font "Inconsolata 18")

;; kill the damn tool/menu/scrollbars.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

(use-package color-theme-sanityinc-tomorrow
  :config
  (load-theme 'sanityinc-tomorrow-day t t)
  (load-theme 'sanityinc-tomorrow-eighties t t))
(use-package mbo70s-theme :config (load-theme 'mbo70s t t))
;; other good themes, omitted here: tronesque, tron, cyberpunk, organic-green, goose

(require 'solar)

(use-package theme-changer
  :load-path "~/src/theme-changer"
  :init
  (setq calendar-location-name "Montreal, QC"
        calendar-latitude 45.5017
        calendar-longitude -73.5673)
  :config
  (change-theme 'sanityinc-tomorrow-day 'sanityinc-tomorrow-eighties))

(show-paren-mode t)                     ; highlight parenthesis matches.
(setq-default
 even-window-heights nil               ; I don't like emacs destroying my window setup
 resize-mini-windows nil
 cursor-in-non-selected-windows nil    ; Don't show a cursor in other windows
 scroll-preserve-screen-position 'keep ; Scrolling is moving the document, not moving my eyes
 inhibit-startup-message t             ; we know where we are.
 x-stretch-cursor t                    ; A wide characters ask for a wide cursor
 x-select-enable-clipboard t ; can kill these when emacs 25 is everywhere
 x-select-enable-primary t
 select-enable-clipboard t
 select-enable-primary t
 save-interprogram-paste-before-kill t
 mouse-yank-at-point t ; I want a mouse yank to be inserted where the point is, not where i click
 mouse-highlight 1) ; Don't highlight stuff that I can click on all the time. I don't click anyways.
(blink-cursor-mode -1)                  ; less wakeups: save power.
(mouse-avoidance-mode 'banish)          ; get the rodent out of my way.
(setq ring-bell-function 'ignore)       ; stop triggering curtis


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

(setq-default show-trailing-whitespace t
              comment-style 'extra-line ; nice comment format
              indent-tabs-mode nil)
(setq make-backup-files nil)            ; herecy, I know.
(put 'narrow-to-region 'disabled nil)   ; don't bitch at me for using ^Xnn
(put 'downcase-region 'disabled nil)
(set-fill-column 74)                    ; not quite standard.
(delete-selection-mode -1)
(set-language-environment "UTF-8")      ; anything ken invented must be good.
(prefer-coding-system 'utf-8)           ;   ditto.

(use-package compile
  :config
  (setq compilation-scroll-output 'first-error)
  ;; handle colored output in compilation mode
  (use-package ansi-color
    :config
    (add-hook 'compilation-filter-hook
              (lambda ()
                (when (eq major-mode 'compilation-mode)
                  (ansi-color-apply-on-region compilation-filter-start (point-max)))))))

(unless (eql system-type 'windows-nt)
  (use-package autorevert
    :config
    (global-auto-revert-mode 1)
    (setq global-auto-revert-non-file-buffers t
          auto-revert-verbose nil)))

(random t)                              ; Do random numbers

(auto-compression-mode 1)   ; transparently work with compressed files

(setq-default
 tab-always-indent 'complete
 dabbrev-case-replace t                ; match case with M-/
 display-time-24hr-format t            ; No am/pm here
 default-tab-width 8                   ; A tab is 8 spaces is 8 spaces is 8 spaces
 apropos-do-all t)


;;;; PACKAGES

(defun js--save-and-leave-emacsclient () (interactive)
  (save-buffer) (server-edit))
(use-package sendmail
  :mode "/mutt-.*"
  :bind (:map mail-mode-map ("C-c C-c" . js--save-and-leave-emacsclient))
  :config (add-hook 'mail-mode-hook #'turn-on-auto-fill))

(use-package ido
  :config
  (setq ido-use-filename-at-point 'guess
        ido-enable-flex-matching t
        ido-create-new-buffer 'always)
  (ido-mode 1)
  (ido-everywhere 1))
(use-package flx-ido :config (flx-ido-mode t))
(use-package ido-ubiquitous :config (ido-ubiquitous-mode 1))
(use-package smex
  :bind (([remap execute-extended-command] . smex)
         ("M-x" . smex)))
(use-package idomenu)

(use-package re-builder
  :config (setq reb-re-syntax 'string))

(use-package color-identifiers-mode
  :config
  (color-identifiers-mode t)
  (delight 'color-identifiers-mode))

(use-package hl-line
  :config (global-hl-line-mode t))

(use-package ws-butler
  :config (ws-butler-global-mode t))

(require 'dired-x)
(use-package dired-rainbow)
(defun dired-back-to-top () (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))
(defun dired-jump-to-bottom () (interactive)
  (end-of-buffer)
  (dired-next-line -1))
(bind-keys
 :map dired-mode-map
 ([remap beginning-of-buffer] . dired-back-to-top)
 ([remap end-of-buffer] . dired-jump-to-bottom))

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

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package ag)

(use-package bury-successful-compilation
  :config (bury-successful-compilation-turn-on))

(use-package dictionary
  :commands (dictionary dictionary-search))

(use-package whitespace
  :config
  (setq-default
   whitespace-style '(face tabs lines-tail trailing indentation)
   whitespace-line-column 80)
  (global-whitespace-mode t))

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

(use-package midnight)

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

(use-package company
  :ensure t
  :config
  (define-key company-mode-map [remap hippie-expand] 'company-complete)
  (define-key company-active-map [remap hippie-expand] 'company-complete)
  (global-company-mode 1)
  (use-package company-c-headers
    :config (add-to-list 'company-backends 'company-c-headers))
  (use-package company-quickhelp :config (company-quickhelp-mode 1))
  (use-package company-statistics :config (company-statistics-mode 1)))

(use-package flycheck
  :config
  (global-flycheck-mode 1)
  (setq flycheck-check-syntax-automatically '(mode-enabled save))

  (use-package flycheck-color-mode-line
    :config
    (add-hook 'flycheck-mode-hook #'flycheck-color-mode-line-mode))

  (use-package flycheck-checkbashisms)
  (use-package flycheck-cstyle)
  (use-package flycheck-pony)
  (use-package flycheck-rebar3 :config (flycheck-rebar3-setup))
  (use-package flycheck-tcl))

(use-package logview)
(use-package niceify-info
  :config (add-hook 'Info-selection-hook #'niceify-info))
(use-package ninja-mode)
(use-package mingus)
(use-package modern-cpp-font-lock)

(use-package writegood-mode
  :config
  (add-hook 'text-mode #'writegood-turn-on))

(use-package snakehump)
(use-package ssh-file-modes)
(use-package unbound)
(use-package volume)
(use-package verify-url)

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

(use-package semantic
  :config
  (global-semanticdb-minor-mode 1)
  (global-semantic-idle-scheduler-mode 1)
  (add-hook 'prog-mode-hook #'semantic-mode))

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode))

(bind-key* "C-j" #'eval-print-last-sexp
           :lisp-interaction-mode-map)

(use-package slime
  :config
  (use-package slime-company)
  (slime-setup '(slime-fancy slime-asdf slime-banner slime-autodoc
                             slime-editing-commands slime-references slime-indentation
                             slime-company))
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

(use-package geiser)

(use-package elisp-slime-nav
  :config (add-hook 'emacs-lisp-mode-hook #'elisp-slime-nav-mode))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(add-to-list 'load-path "~/src/elisp/")

(use-package cc-mode
  :config
  (use-package cwarn
    :config (global-cwarn-mode t))
  (use-package c-eldoc
    :config (add-hook 'c-mode-hook 'c-turn-on-eldoc-mode))

  (require 'cc-mode-append-include nil nil)

  (require 'eassist)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (bind-keys :map c-mode-base-map
                         ;; XXX should consider C-c C-a instead of M-o to be like tuareg-mode
                         ("M-o" . eassist-switch-h-cpp)
                         ("M-m" . eassist-list-methods))))

  (use-package google-c-style)
  (require 'js-c-style)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (google-set-c-style)
              (c-add-style "JS" js-cpp-style t))))

(use-package dtrt-indent
  :config (dtrt-indent-mode 1))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (use-package markdown-mode+)
  (use-package markdown-toc))

(use-package java-imports)
(use-package javadoc-lookup)

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

(use-package gnu-apl-mode)

(use-package j-mode
  :config (setq j-console-cmd "ijconsole"))

(use-package erlang
  :config (require 'erlang-start))

(use-package ponylang-mode
  :config
  (add-hook
   'ponylang-mode-hook
   (lambda ()
     (set-variable 'indent-tabs-mode nil)
     (set-variable 'tab-width 2))))

(use-package tuareg
  :bind (:map tuareg-mode-map ("C-c C-z" . utop)))

(use-package utop
  :commands (utop utop-setup-ocaml-buffer))

(use-package ocp-indent)
(use-package merlin
  :bind (:map merlin-mode-map
         ("M-." . merlin-locate)
         ("M-," . merlin-pop-stack))
  :config
  ;; Start merlin on ocaml files
  (add-hook 'tuareg-mode-hook (lambda () (merlin-mode 1)))
  (add-hook 'caml-mode-hook (lambda () (merlin-mode 1)))
  ;; Use opam switch to lookup ocamlmerlin binary
  (setq merlin-command 'opam))

(use-package glsl-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.vert$" . glsl-mode))
  (add-to-list 'auto-mode-alist '("\\.frag$" . glsl-mode)))


;;;; finally...

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

(setq debug-on-error nil
      debug-on-quit nil)
