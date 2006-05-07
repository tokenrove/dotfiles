;;;
;;; emacs configuration
;;; Julian Squires <julian@cipht.net> / 2003-2006
;;;

;;;; emacs' own customization stuff
(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(ecb-options-version "2.27")
 '(load-home-init-file t t)
 '(noweb-code-mode (quote lisp-mode)))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(default ((t (:stipple nil :background "#233b5a" :foreground "#fff8dc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :family "xos4-terminus")))))

;;
;; Random important emacs customizations
;;

(if (featurep 'xemacs)			; highlight parenthesis matches
    (paren-set-mode 'sexp)
  (show-paren-mode))
(if (featurep 'xemacs)			; always do syntax highlighting
    (setq-default font-lock-auto-fontify t)
  (global-font-lock-mode))
(put 'narrow-to-region 'disabled nil)   ; don't bitch at me for using ^Xnn
(column-number-mode t)                  ; show column numbers
(auto-fill-mode)                        ; wrap lines and so on.
(set-fill-column 74)                    ; not quite standard.
(c-set-style "k&r")                     ; don't use that damn gnu style.
(delete-selection-mode 1)		; fast and loose selections.
(setq backup-by-copying-when-linked t)	; don't fuck over hardlinked files.
(mouse-avoidance-mode 'cat-and-mouse)	; get the rodent out of my way
(set-language-environment "UTF-8")

;;;; BINDINGS
;; some random key bindings
(global-set-key "\C-z" 'shell)          ; spawn a shell when muscle-memory
                                        ; causes ^Z
(global-set-key [?\M-S] 'goto-line)     ; old xemacs habits die hard, but
                                        ; M-g was taken.
(global-set-key [?\C-|] 'move-to-column) ; Almost vi-ish.

;; Dvorak bindings.
(global-set-key [?\C-.] 'execute-extended-command)
(global-set-key [?\C-,] (lookup-key global-map [?\C-x]))

;;;; LISPY LISPY LISP
(require 'cl)

;;; Stolen from bdowning's emacs

(defun move-past-close-and-space ()
  "bleh"
  (interactive)
  (backward-up-list)
  (forward-sexp)
  (insert " "))

(defun custom-lisp-keybindings ()
 (local-set-key "[" 'insert-parentheses)
 (local-set-key "]" 'move-past-close-and-reindent)
 (local-set-key "}" 'move-past-close-and-space)
 (local-set-key [\C-\M-backspace] 'backward-kill-sexp))

;; Prompt before evaluating local bits of lisp.  This stops people
;; putting things at the end of files which delete all your files!
(setq enable-local-variables t
      enable-local-eval      1)

;;; End of stuff stolen from bdowning.


;;; share/elisp/ stuff
(add-to-list 'load-path "/home/julian/.elisp/")

;;;; CUTENESS

;; kill the damn tool/menu/scrollbars.
(if (featurep 'xemacs)
    (progn
      (set-specifier default-toolbar-visible-p nil)
      (set-specifier horizontal-scrollbar-visible-p nil)
      (set-specifier vertical-scrollbar-visible-p nil)
      (set-specifier menubar-visible-p nil))
  (tool-bar-mode nil)
  (scroll-bar-mode nil)
  (menu-bar-mode nil))

;; color theme
(require 'color-theme)
;(color-theme-subtle-hacker)
;(color-theme-charcoal-black)
(color-theme-dark-blue2)
;(color-theme-feng-shui)

;; buffer switch with ^tab
(require 'pc-bufsw)
(pc-bufsw::bind-keys [(control tab)] [(shift control tab)])

;;;; SLIME STUFF
(add-to-list 'load-path "/home/julian/.slime/")
(set 'inferior-lisp-program "openmcl")
(require 'slime)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;; XXX only for SBCL?
(setq slime-net-coding-system 'utf-8-unix)

;; ACL ELI stuff
;(add-to-list 'load-path "/usr/lib/acl/eli")
;(load "/usr/lib/acl/eli/fi-site-init")

;; from the SLIME page on cliki.net -- make (if) indent properly.
(add-hook 'lisp-mode-hook
          (defun my-lisp-mode-hook ()
            (set (make-local-variable 'lisp-indent-function)
                 'common-lisp-indent-function)))

;;;; NOWEB

(require 'noweb)
(add-to-list 'auto-mode-alist '("\\.nwcl\\'" . noweb-mode))

;;;; DARCS
;(require 'vc-darcs)
;(add-to-list 'vc-handled-backends 'DARCS)


;;;; BBDB

(require 'bbdb)
;;Tell bbdb about your email address:
(setq bbdb-user-mail-names
      (regexp-opt '("julian@cipht.net"
                    "tek@wiw.org")))
;;cycling while completing email addresses
(setq bbdb-complete-name-allow-cycling t)
;;No popup-buffers
(setq bbdb-use-pop-up nil)

;;;; MAILCRYPT

;; Always sign encrypted messages
(setq mc-pgp-always-sign t)
;(add-hook 'message-send-hook 'my-sign-message)
;(defun my-sign-message ()
;    (if (yes-or-no-p "Sign message? ")
;            (mc-sign-message)))

;;;; RANDOM PACKAGES
(autoload 'typing-of-emacs "typing" "The Typing Of Emacs, a game." t)
