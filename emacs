;;;
;;; emacs configuration
;;; Julian Squires <julian@greyfirst.ca> / 2003
;;;

;;
;; Random important emacs customizations
;;

(show-paren-mode)                       ; highlight parenthesis matches
(global-font-lock-mode)                 ; always do syntax highlighting
(put 'narrow-to-region 'disabled nil)   ; don't bitch at me for using ^Xnn
(column-number-mode t)                  ; show column numbers
(auto-fill-mode)                        ; wrap lines and so on.
(set-fill-column 74)                    ; not quite standard.
(c-set-style "k&r")                     ; don't use that damn gnu style.
(delete-selection-mode 1)		; fast and loose selections.

;; some key bindings

(global-set-key "\C-z" 'shell)          ; spawn a shell when muscle-memory
                                        ; causes ^Z
(global-set-key [?\M-S] 'goto-line)     ; old xemacs habits die hard, but
                                        ; M-g was taken.


;; lispy lispy lisp and other emacs prettiness changes
(show-paren-mode)
(tool-bar-mode nil)
(scroll-bar-mode nil)
(menu-bar-mode nil)


;;; share/elisp/ stuff
(add-to-list 'load-path "/home/tek/.elisp/")

;; color theme
(require 'color-theme)
;(color-theme-subtle-hacker)
;(color-theme-charcoal-black)
(color-theme-dark-blue2)
;(color-theme-feng-shui)

;; buffer switch with ^tab
(require 'pc-bufsw)
(pc-bufsw::bind-keys [(control tab)] [(shift control tab)])


;;; SLIME stuff
(add-to-list 'load-path "/home/tek/.slime/")
(set 'inferior-lisp-program "sbcl --noinform")
(require 'slime)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

;; ACL ELI stuff
;(add-to-list 'load-path "/usr/lib/acl/eli")
;(load "/usr/lib/acl/eli/fi-site-init")

;; from the SLIME page on cliki.net -- make (if) indent properly.
(add-hook 'lisp-mode-hook
          (defun my-lisp-mode-hook ()
            (set (make-local-variable 'lisp-indent-function)
                 'common-lisp-indent-function)))

;;;; Planner stuff

(set 'planner-directory "~/.plans")
;(set 'planner-publishing-directory "~/public_html/wiki")
(set 'mark-diary-entries-in-calendar t)

;;;; emacs' own customization stuff
(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(case-fold-search t)
 '(current-language-environment "English")
 '(global-auto-revert-mode t nil (autorevert))
 '(global-font-lock-mode t nil (font-lock))
 '(show-paren-mode t nil (paren))
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 )
