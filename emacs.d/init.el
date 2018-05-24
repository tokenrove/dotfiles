;;;; assembled by magpies

(setq debug-on-error t
      debug-on-quit t)

(eval-when-compile (require 'cl))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(add-to-list 'load-path "~/src/elisp/")

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file t)

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

;;; I probably don't need to do this anymore, but I used to need this
;;; because I'd depend on debian-installed emacs packages, but use my
;;; own emacs compiled from source.
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
  :init
  (load-theme 'sanityinc-tomorrow-day t t)
  (load-theme 'sanityinc-tomorrow-night t t)
  (load-theme 'sanityinc-tomorrow-eighties t t))

(use-package abyss-theme :init (load-theme 'abyss t t))
(use-package cyberpunk-theme :init (load-theme 'cyberpunk t t))
(use-package goose-theme :init (load-theme 'goose t t))
(use-package hydandata-light-theme :init (load-theme 'hydandata-light t t))
(use-package mbo70s-theme :init (load-theme 'mbo70s t t))
(use-package organic-green-theme :init (load-theme 'organic-green t t))
(use-package sea-before-storm-theme :init (load-theme 'sea-before-storm t t))
(use-package silkworm-theme :init (load-theme 'silkworm t t))
(use-package soft-morning-theme :init (load-theme 'soft-morning t t))
(use-package soft-stone-theme :init (load-theme 'soft-stone t t))
(use-package tronesque-theme :init (load-theme 'tronesque t t))
(use-package twilight-bright-theme :init (load-theme 'twilight-bright t t))
(use-package underwater-theme :init (load-theme 'underwater t t))
(use-package kaolin-themes
  :init
  (dolist (theme '(kaolin-dark kaolin-ocean kaolin-light kaolin-galaxy kaolin-eclipse))
    (load-theme theme t t)))
(use-package challenger-deep-theme :init (load-theme 'challenger-deep t t))

(require 'solar)

(use-package theme-changer
  :ensure nil
  :pin manual
  :load-path "~/src/theme-changer"
  :init
  (setq calendar-location-name "Montreal, QC"
        calendar-latitude 45.5017
        calendar-longitude -73.5673)
  :config
  (change-theme
   '(goose
     hydandata-light
     kaolin-light
     organic-green
     sanityinc-tomorrow-day
     silkworm
     soft-morning
     soft-stone
     twilight-bright)
   '(abyss
     cyberpunk
     kaolin-dark
     kaolin-eclipse
     kaolin-galaxy
     kaolin-ocean
     mbo70s
     sanityinc-tomorrow-eighties
     sanityinc-tomorrow-night
     sea-before-storm
     tronesque
     underwater
     challenger-deep)))

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
              indent-tabs-mode nil
              sort-fold-case t)
(setq make-backup-files nil)            ; herecy, I know.
(dolist (f '(downcase-region narrow-to-region timer-list))
  (put f 'disabled nil))
(set-fill-column 74)                    ; not quite standard.
(delete-selection-mode -1)
(set-language-environment "UTF-8")      ; anything ken invented must be good.
(prefer-coding-system 'utf-8)           ;   ditto.

(use-package compile
  :config
  (add-hook 'compilation-mode-hook 'visual-line-mode)
  (setq compilation-scroll-output 'first-error)
  ;; handle colored output in compilation mode
  (use-package ansi-color
    :config
    (add-hook 'compilation-filter-hook
              (lambda ()
                (when (eq major-mode 'compilation-mode)
                  (ansi-color-apply-on-region compilation-filter-start (point-max))))))
  (use-package bury-successful-compilation
    :config (bury-successful-compilation-turn-on)))

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

(defun sort-words (reverse begin end)
  "Sort the words in a region."
  (interactive "P\nr\n")
  (let ((re "\\(?:\\s_\\|\\w\\|\\s.\\)+"))
    (sort-regexp-fields reverse re re begin end)))


;;;; PACKAGES

(use-package auth-password-store :config (auth-pass-enable))

(defun js--save-and-leave-emacsclient ()
  (interactive) (save-buffer) (server-edit))
(use-package muttrc-mode)
(use-package sendmail
  :mode ("/mutt-.*" . mail-mode)
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
(use-package ido-completing-read+
  :config (ido-ubiquitous-mode 1))
(use-package smex
  :bind (([remap execute-extended-command] . smex)
         ("M-x" . smex))
  :config
  (smex-initialize)
  (setq smex-auto-update nil))
(use-package idomenu)

(use-package re-builder
  :config (setq reb-re-syntax 'string))

(use-package color-identifiers-mode
  :config
  (global-color-identifiers-mode t))

(use-package hl-line
  :config (global-hl-line-mode t))

(use-package ws-butler
  :config
  (ws-butler-global-mode t)
  ;; ws-butler mangles the dash dash space in signatures.
  (add-hook 'mail-mode-hook (lambda () (ws-butler-mode 0))))

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

;;; Still to decide:
;;;  - NEXT as tag or as todo state
;;;  - STARTED as todo state or indicated by clocking
(use-package org
  :defer t
  :bind
  (("<f12>" . org-agenda)
   ("<f11>" . org-clock-goto)
   ("C-M-r" . org-capture))
  :config
  ;; don't fuck with my C-,
  (add-hook 'org-mode-hook
            (lambda () (define-key org-mode-map [?\C-,] (lookup-key global-map [?\C-x]))))
  (setq org-directory "~/org"
        org-agenda-files (list org-directory)
        js-org-journal-file (expand-file-name (concat "journal-" (format-time-string "%Y") ".org") org-directory)
        js-org-calendar-file (expand-file-name "google-calendar.org" org-directory)
        org-modules (union org-modules '(org-habit org-depend org-protocol))
        org-default-notes-file (expand-file-name "refile.org" org-directory)
        org-capture-templates
        `(("t" "todo" entry (file org-default-notes-file)
           "* TODO %?\nSCHEDULED: %^t\n%U\n%a\n  %i" :clock-in t :clock-resume t)
          ("n" "note" entry (file org-default-notes-file)
           "* %? :NOTE:\n%U\n%a\n  %i" :clock-in t :clock-resume t)
          ;; Need to fix this up so it reuses the existing heading, at some point
          ("j" "Journal" entry (file+olp+datetree ,js-org-journal-file)
           "* %U\n\n%?" :clock-in t :clock-resume t)
          ("w" "org-protocol" entry (file org-default-notes-file)
           "* TODO Review %c\n%U\n  %i" :immediate-finish t)
          ("i" "Interruption" entry (file org-default-notes-file)
           "* INTERRUPTION %?\n%U" :clock-in t :clock-resume t)
          ("a" "Appointment" entry (file ,js-org-calendar-file)
           "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n"))
        org-catch-invisible-edits 'show-and-error ; protect me
        org-extend-today-until 5        ; the day starts anew at 5am
        org-log-done '(time)            ; timestamp done tasks
        org-log-into-drawer t           ; tidier
        org-clock-out-remove-zero-time-clocks t
        org-clock-idle-time 5
        ;; XXX should probably make sure this exists on the system
        org-clock-x11idle-program-name "xprintidle"
        org-x11idle-exists-p t
        ;; log mode is a nicer way to see the day
        org-agenda-log-mode-items '(closed clock state)
        org-agenda-start-with-log-mode t
        org-agenda-span 1               ; show one day by default
        org-agenda-todo-ignore-deadlines 'far ; show upcoming deadlines
        org-agenda-todo-ignore-scheduled 'future
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-timestamp-if-done t
        org-agenda-compact-blocks t     ; XXX nicer?
        org-use-speed-commands t        ; single-char commands
        org-yank-adjusted-subtrees t
        org-todo-keywords '((sequence
                             "TODO(t)" "WAITING(w@/!)" "SOMEDAY(S!)" "|"
                             "DONE(d!/!)" "CANCELLED(c@/@)" "DELEGATED(D@/@)"))
        org-todo-state-tags-triggers '(("CANCELLED" ("CANCELLED" . t))
                                       ("WAITING" ("WAITING" . t))
                                       ("SOMEDAY" ("WAITING" . t))
                                       ("DELEGATED" ("WAITING" . t))
                                       (done ("WAITING"))
                                       ("TODO" ("WAITING") ("CANCELLED"))
                                       ("DONE" ("WAITING") ("CANCELLED")))
        org-agenda-custom-commands '(("w" "Waiting and Postponed tasks" todo "WAITING|SOMEDAY"
                                      ((org-agenda-overriding-header "Waiting Tasks")))
                                     ("r" "Refile New Notes and Tasks" tags "REFILE"
                                      ((org-agenda-todo-ignore-with-date nil)
                                       (org-agenda-todo-ignore-deadlines nil)
                                       (org-agenda-todo-ignore-scheduled nil)
                                       (org-agenda-todo-ignore-timestamp nil)
                                       (org-agenda-overriding-header "Tasks to Refile"))))
        org-habit-graph-column 60)
  (use-package org-protocol :ensure nil)
  (use-package org-checklists :ensure nil)
  (use-package ox-ioslide :defer t)
  (use-package org-gcal
    :config
    (let ((secret (plist-get (first (auth-source-search :host "google.com" :user "julian.squires@gmail.com-org-gcal-sync")) :secret)))
      (setq org-gcal-client-id "235233077990-f3ti3fdembukje38lio95tjkfntimard.apps.googleusercontent.com"
            org-gcal-client-secret (if (functionp secret) (funcall secret) secret)
            org-gcal-file-alist `(("julian.squires@gmail.com" . ,js-org-calendar-file))))))


(defvar libnotify-program "/usr/bin/notify-send")
(defun notify-send (title message)
  (start-process "notify" " notify"
                 libnotify-program "--expire-time=4000" title message))

(use-package griffin
  :defer t
  :ensure nil
  :load-path "~/src/griffin"
  :commands (griffin))

(use-package company
  :ensure t
  :config
  (define-key company-mode-map [remap hippie-expand] 'company-complete)
  (define-key company-active-map [remap hippie-expand] 'company-complete)
  (global-company-mode 1)
  (use-package company-c-headers
    :config (add-to-list 'company-backends 'company-c-headers))
  (use-package company-statistics :config (company-statistics-mode 1)))

(use-package flycheck
  :config
  (global-flycheck-mode 1)
  (setq flycheck-check-syntax-automatically '(mode-enabled save))
  (add-to-list 'flycheck-disabled-checkers 'emacs-lisp-checkdoc)

  (use-package flycheck-color-mode-line
    :config
    (add-hook 'flycheck-mode-hook #'flycheck-color-mode-line-mode))

  (use-package flycheck-checkbashisms
    :config (add-to-list 'flycheck-checkers 'sh-checkbashisms))
  (use-package flycheck-pony
    :config (add-to-list 'flycheck-checkers 'pony))
  (use-package flycheck-rebar3 :config (flycheck-rebar3-setup))
  (use-package flycheck-tcl)
  (use-package flycheck-checkpatch
    :config (flycheck-checkpatch-setup)))

(use-package logview)
(use-package niceify-info
  :config (add-hook 'Info-selection-hook #'niceify-info))

(use-package ninja-mode)
(use-package meson-mode)

(use-package modern-cpp-font-lock)

(use-package writegood-mode
  :config
  (dolist (m '(text-mode-hook mail-mode-hook markdown-mode-hook))
    (add-hook m #'writegood-turn-on)))

(use-package snakehump)
(use-package ssh-file-modes)
(use-package unbound)

(use-package mingus)
(use-package volume)

(use-package verify-url)

(use-package git-gutter
  :ensure t
  :init (global-git-gutter-mode)
  :config (setq git-gutter:update-interval 1))

(use-package nix-mode)

;;;; KEY BINDINGS

(bind-keys
 ("M-/"      . dabbrev-expand)
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

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  (define-key paredit-mode-map (read-kbd-macro "C-j") nil))

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

(use-package x86-lookup
  :config
  (setq x86-lookup-pdf "~/ref/325383-sdm-vol-2abcd.pdf"))
(use-package nasm-mode)

(use-package cc-mode
  :config
  (c-add-style "backtrace"
              '("bsd"
                (c-syntactic-indentation-in-macros . nil)
                (c-hanging-braces-alist
                 (block-close . c-snug-do-while))
                (c-offsets-alist
                 (arglist-cont-nonempty . *)
                 (statement-cont . *))
                (indent-tabs-mode . t)))
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

(use-package toml-mode)

(use-package graphviz-dot-mode)

(use-package java-imports)
(use-package javadoc-lookup)

(use-package zeal-at-point
  :config (global-set-key "\C-cz" 'zeal-at-point))

(use-package scala-mode)

(use-package csharp-mode
  :mode "\\.cs$"
  :config (add-hook 'csharp-mode-hook (lambda () (local-set-key "{" 'c-electric-brace))))

(use-package fsharp-mode
  :commands (fsharp-mode run-fsharp)
  :mode "\\.fs[iylx]?$"
  :config
  (setq inferior-fsharp-program "fsi --readline-"
        fsharp-compiler "fsc"))

(use-package forth-mode)

(use-package fuel
  :config
  (setq fuel-factor-root-dir "~/lib/factor"))

(use-package cperl-mode
  :init
  (defalias 'perl-mode 'cperl-mode)
  :config
  (setq cperl-hairy t))

;; (use-package lilypond-mode
;;   :load-path "/usr/local/"
;;   :config (setq LilyPond-pdf-command "zathura"))

(use-package gnu-apl-mode)


(use-package haskell-mode
  :config
  (use-package flycheck-haskell
    :commands flycheck-haskell-setup)
  (setq-default
   haskell-process-type 'stack-ghci
   haskell-process-load-or-reload-prompt t
   haskell-interactive-mode-scroll-to-bottom t
   haskell-font-lock-symbols t)
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))

(use-package j-mode
  :config (setq j-console-cmd "ijconsole"))

(use-package julia-mode
  :config
  (use-package julia-shell))

(use-package lua-mode
  :config
  (use-package company-lua))

(use-package erlang
  :config
  (require 'erlang-start)
  (setq erlang-check-module-name t)
  (use-package company-erlang))

(use-package ponylang-mode
  :config
  (add-hook
   'ponylang-mode-hook
   (lambda ()
     (set-variable 'indent-tabs-mode nil)
     (set-variable 'tab-width 2))))

(use-package python
  :config
  (use-package auto-virtualenv
    :config
    (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)))

(use-package sage-shell-mode)

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

(use-package rust-mode
  :config
  (use-package cargo
    :config
    (add-hook 'rust-mode-hook 'cargo-minor-mode))
  (use-package racer
    :config
    (setq racer-cmd "~/.cargo/bin/racer"
          racer-rust-src-path "~/build/rust/src")
    (add-hook 'rust-mode-hook #'racer-mode)
    (add-hook 'racer-mode-hook #'eldoc-mode)
    (add-hook 'racer-mode-hook #'company-mode))
  (use-package flycheck-rust
    :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package yaml-mode)


;;;; finally...

(use-package pinentry
  :config
  (pinentry-start))

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

(setq debug-on-error nil
      debug-on-quit nil)
