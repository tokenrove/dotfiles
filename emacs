;;
;; Teknovore (tek@wiw.org)'s emacs setup
;;

;; First, some nice stuff borrowed from Rik Faith

;;(require 'delbs.el)

(setq enable-local-variables  1)
(setq gc-cons-threshold 1000000)

(if (boundp 'device-type)
    (if (eq 'tty (device-type))
        (set-device-class nil 'color)))

;;; These version examination commands are from etc/sample.emacs in the
;;; XEmacs 19.13 distribution.
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))
(if (not (boundp 'prefix-directory)) (defvar prefix-directory "/usr"))
(if (and (not (boundp 'emacs-major-version))
	 (string-match "^[0-9]+" emacs-version))
    (setq emacs-major-version
	  (string-to-int (substring emacs-version
				    (match-beginning 0) (match-end 0)))))
(if (and (not (boundp 'emacs-minor-version))
	 (string-match "^[0-9]+\\.\\([0-9]+\\)" emacs-version))
    (setq emacs-minor-version
	  (string-to-int (substring emacs-version
				    (match-beginning 1) (match-end 1)))))
(defun running-emacs-version-or-newer (major minor)
  (or (> emacs-major-version major)
      (and (= emacs-major-version major)
	   (>= emacs-minor-version minor))))

(if (and (not running-xemacs) (and (eq window-system 'x) (x-display-color-p)))
    (progn
                                        ; Mouse selection stuff
      (require 'mouse-sel)
      (make-face 'new-mouse-highlight)
      (set-face-background 'new-mouse-highlight "blue")
      (overlay-put mouse-drag-overlay 'face 'new-mouse-highlight)
      (setq mouse-sel-retain-highlight t)

      (require 'faces)
      (set-face-background 'highlight "red")
      (set-face-foreground 'highlight "yellow")

                                        ; Hilite stuff

      (setq hilit-mode-enable-list  '(not text-mode)
            hilit-background-mode   'dark
            hilit-inhibit-hooks     nil
            hilit-inhibit-rebinding nil)

      (require 'hilit19)

                                        ; used for C/C++ and elisp and perl

      (hilit-translate comment      'moccasin
                       include      'Plum1
                       define       'Plum1
                       defun        'cyan
                       decl         'cyan
                       type         'default
                       keyword      'moccasin
                       label        'moccasin
                       string       'green3)

                                        ; some further faces for Ada
      (hilit-translate struct       'cyan
                       glob-struct  'cyan
                       named-param  'cyan)

                                        ; and another one for LaTeX
      (hilit-translate crossref     'Plum1)

                                        ; Makefiles
      (hilit-translate rule         'cyan)

                                        ; Info
      (hilit-translate jargon-entry 'green3
                       jargon-xref  'cyan)
      ))

                                        ; Set up XEmacs stuff
(if running-xemacs
    (paren-set-mode 'paren)
  (setq blink-matching-paren t))
(if (and running-xemacs (and (eq window-system 'x) (x-display-color-p)))
    (progn
      ;; miscellaneous
      (setq frame-icon-title-frame (concat "%S@" (system-name)))
      (setq frame-icon-title-format (concat "%S@" (system-name)))
      (setq frame-title-format (concat "%S@" (system-name)))
      (define-key global-map [(control button1)] 'popup-buffer-menu)
      (setq buffers-menu-max-size 60)
      (if (running-emacs-version-or-newer 19 14)
          (set-specifier default-toolbar-visible-p nil))

      ;; text cursor
      (setq default-frame-plist '(cursor-color "red"))
;      (set-frame-width (selected-frame) 80)
;      (set-frame-height (selected-frame) 43)

      (setq initial-frame-plist default-frame-plist)
      (setq bar-cursor nil)

      ;; mouse cursor (the pointer)
      (if (running-emacs-version-or-newer 19 14)
          (set-face-foreground 'pointer "red"))

      ;; fonts
;      (set-face-font 'italic  "-misc-fixed-medium-r-normal-*-15-*")
;      (set-face-font 'bold-italic "-misc-fixed-bold-r-normal-*-15-*")
      (copy-face 'default 'italic)
      (copy-face 'bold 'bold-italic)
;      (set-face-font 'modeline "-*-lucidatypewriter-*-*-*-*-12-*")
;      (set-face-font 'modeline-mousable-minor-mode "-*-lucidatypewriter-*-*-*-*-12-*")


      ;; selections
      (setq zmacs-regions t)

      ;; colors of stuff
      (setq x-pointer-foreground-color "red")
      (setq x-pointer-background-color "black")

      ;; font-lock mode
      (setq font-lock-use-default-fonts nil)
      (setq font-lock-use-default-colors nil)
      (setq font-lock-use-maximal-decoration t)
      (require 'font-lock)
;      (set-face-font 'bold (face-font 'default))
      (set-face-font 'bold-italic (face-font 'bold))
      (copy-face 'default 'font-lock-comment-face)
      (copy-face 'default 'font-lock-doc-string-face)
      (copy-face 'default 'font-lock-function-name-face)
      (copy-face 'default 'font-lock-preprocessor-face)
      (copy-face 'default 'font-lock-keyword-face)
      (copy-face 'default 'font-lock-type-face)
      (copy-face 'default 'font-lock-string-face)
      (copy-face 'default 'font-lock-variable-name-face)

      (make-face 'font-lock-math-face)
      (copy-face 'default 'font-lock-math-face)
      (make-face 'font-lock-decl-face)
      (copy-face 'default 'font-lock-decl-face)

      (if (string-equal (color-name (face-foreground 'default)) "black")
          (progn
            (set-face-background 'zmacs-region "blue")
            (set-face-foreground 'highlight "yellow")
            (set-face-background 'highlight "red")
            (set-face-background 'isearch "blue")
            (set-face-background 'paren-match "blue")
            (set-face-background 'paren-mismatch "orange")
            (set-face-background 'secondary-selection "orange")

            (set-face-foreground 'font-lock-comment-face "firebrick")
            (set-face-foreground 'font-lock-string-face "darkgreen")
            ;      (set-face-foreground 'font-lock-string-face "yellow")
            (set-face-foreground 'font-lock-doc-string-face
                                 (face-foreground 'font-lock-string-face))
            (set-face-foreground 'font-lock-function-name-face "blue")
            ;      (set-face-foreground 'font-lock-keyword-face "goldenrod")
            (set-face-foreground 'font-lock-keyword-face "firebrick")
            (set-face-foreground 'font-lock-preprocessor-face "darkgreen")
            ;      (set-face-foreground 'font-lock-type-face "goldenrod")
            (set-face-foreground 'font-lock-math-face "goldenrod")
            (set-face-foreground 'font-lock-decl-face "blue"))
        (progn
          (set-face-background 'zmacs-region "blue")
          (set-face-foreground 'highlight "yellow")
          (set-face-background 'highlight "red")
          (set-face-background 'isearch "blue")
          (set-face-background 'paren-match "blue")
          (set-face-background 'paren-mismatch "orange")
          (set-face-background 'secondary-selection "orange")

          (set-face-foreground 'font-lock-comment-face "moccasin")
          (set-face-foreground 'font-lock-string-face "green3")
          ;      (set-face-foreground 'font-lock-string-face "yellow")
          (set-face-foreground 'font-lock-doc-string-face
                               (face-foreground 'font-lock-string-face))
          (set-face-foreground 'font-lock-function-name-face "cyan")
          ;      (set-face-foreground 'font-lock-keyword-face "goldenrod")
          (set-face-foreground 'font-lock-keyword-face "moccasin")
          (set-face-foreground 'font-lock-preprocessor-face "Plum1")
          ;      (set-face-foreground 'font-lock-type-face "goldenrod")
          (set-face-foreground 'font-lock-math-face "goldenrod")
          (set-face-foreground 'font-lock-decl-face "cyan"))
        )

      (setq sgml-font-lock-keywords
            (purecopy
             (list
              '("\\(``[^']+''\\)" 1 font-lock-string-face t)
              '("&[^;\n]*;" 0 font-lock-string-face t)
;             '("\\(<[^>]*>\\)" 1 font-lock-preprocessor-face t)
              '("\\(</[^>/]*[>/]\\)" 1 font-lock-preprocessor-face t)
              '("\\(<[^>/]*/[^>/]*/\\)" 1 font-lock-preprocessor-face t)
              '("\\(<[^>/]*[>/]\\)" 1 font-lock-preprocessor-face t)
              '("\\(<![a-z]+\\>[^<>]*\\(<[^>]*>[^<>]*\\)*>\\)"
                1 font-lock-comment-face t)
              ;; Comments: <!-- ... -->. They traditionally override
              ;; anything else.  It's complicated 'cause we won't allow
              ;; "-->" inside a comment, and font-lock colours the
              ;; *longest* possible match of the regexp.
              '("\\(<!--\\([^-]\\|-[^-]\\|--[^>]\\)*-->\\)"
                1 font-lock-comment-face t)
              )))

      ; This one from nroff-mode.el

      (setq nroff-font-lock-keywords
            (purecopy
             (list
              '("^[.']\\\\\".*" 0 font-lock-comment-face t)
              '("[^\\\"]\\(\"[^\\\"]*\"\\)" 1 font-lock-string-face t)
              ;; Directives are . or ' at start of line, followed by
              ;; optional whitespace, then command (which my be longer than
              ;; 2 characters in groff).  Perhaps the arguments should be
              ;; fontified as well.
              '( "^[.']\\s-*\\sw+.*" . font-lock-preprocessor-face)
              ;; There are numerous groff escapes; the following get things
              ;; like \-, \(em (standard troff) and \f[bar] (groff
              ;; variants).  This won't currently do groff's \A'foo' and the
              ;; like properly.  One might expect it to highlight an
              ;; escape's arguments in common cases, like \f.
                        (concat  "\\\\"                       ; backslash
                         "\\(" ; followed by various possibilities
                         (mapconcat 'identity
                                    '("[f*n]*\\[.+]"    ; some groff extensions
                                      "(.."             ; two chars after (
                                      "[^(\"]"          ; single char escape
                                      ) "\\|")
                         "\\)"))
              ))


      (add-hook 'hyper-apropos-mode-hook
               '(lambda ()
                  (copy-face 'default 'hyperlink)
                  (copy-face 'default 'warning)
                  (copy-face 'bold 'major-heading)
                  (copy-face 'bold 'section-heading)
                  (if (string-equal (color-name
                                     (face-foreground 'default)) "black")
                      (progn
                        (set-face-foreground 'hyperlink "blue")
                        (set-face-foreground 'warning "red")
                        (set-face-foreground 'documentation "darkgreen"))
                    (progn
                      (set-face-foreground 'hyperlink "Plum1")
                      (set-face-foreground 'warning "red")
                      (set-face-foreground 'documentation "green3")))))

      (add-hook 'compilation-mode-hook
                '(lambda ()
                   (font-lock-mode 1)))

      ))

                                        ; C/C++ mode
(fmakunbound 'c-mode)
(makunbound 'c-mode-map)
(fmakunbound 'c++-mode)
(makunbound 'c++-mode-map)
(makunbound 'c-style-alist)
(autoload 'c++-mode  "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode    "cc-mode" "C Editing Mode" t)
(autoload 'objc-mode "cc-mode" "Objective-C Editing Mode" t)

;; Customizations for both c-mode and c++-mode
(defun my-c-mode-common-hook ()
  ;; set up for my perferred indentation style, but  only do it once
;;  (or (assoc "tek" c-style-alist)
;;      (setq c-style-alist (cons c-style-alist my-c-style)))
  (c-add-style "tek"
	`( "stroustrup"
    (c-basic-offset                 . 4)
    (c-block-comments-indent-p      . nil)
    (c-tab-always-indent            . t)
    (c-comment-only-line-offset     . 0)
    (c-echo-syntactic-information-p . nil)
    (c-electric-pound-behavior      . 'alignleft)
    (c-recognize-knr-p              . nil)
    (c-hanging-braces-alist         . ((substatement-open before)
                                       (brace-list-open)))
    (c-hanging-colons-alist         . ((member-init-intro before)
                                       (inher-intro)
                                       (case-label after)
                                       (label after)
                                       (access-label after)))
    (c-cleanup-list                 . (brace-else-brace
                                       list-close-comma
                                       defun-close-semi
                                       scope-operator))
    (c-offsets-alist                . ((statement-block-intro . +)
                                       (knr-argdecl-intro . +)
                                       (substatement-open . 0)
                                       (label . -)
                                       (statement-cont . c-lineup-math)))
   ))

  (setq c-style-variables-are-local-p t)
  (setq c-default-style "tek")

  ;; other customizations
  (setq tab-width 8
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)
  ;; we (might) like auto-newline and hungry-delete
  (c-toggle-auto-hungry-state -1)
  ;; keybindings for C, C++, and Objective-C.  We can put these in
  ;; c-mode-map because c++-mode-map and objc-mode-map inherit it
  (define-key c-mode-map "\C-m" 'newline-and-indent)
  (setq modeline-format "--%+%&--L%l--%b-(%m)--%-")
  (setq fume-display-in-modeline-p t)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(setq c-backslash-column 75)


(add-hook 'f90-mode-hook
          (function (lambda ()
                      (define-key f90-mode-map "\C-m" 'f90-indent-new-line)
                      (define-key f90-mode-map "\M-\C-i" 'dabbrev-completion)
                      (font-lock-mode 1)
                      (abbrev-mode 1)
                      )))


;; Quick hack to use alternate shell
(setq explicit-shell-file-name "/bin/sh")
;;(setq c-default-style k&r)
(autoload 'forth-mode "gforth.el")
;;(load "pgp.el")
(display-time)
;;(setq comment-column 43)
(put 'downcase-region 'disabled nil)
(setq line-number-mode t)
(setq column-number-mode t)
;;; default modes
(setq auto-mode-alist
      (mapcar 'purecopy
              '(
                ("\\.el$"      . emacs-lisp-mode)
		("\\.emacs$"   . emacs-lisp-mode)

                ("\\.scm$"     . scheme-mode)

                ("\\.c$"       . c-mode)
                ("\\.h$"       . c-mode)

                ("\\.C$"       . c++-mode)
                ("\\.cc$"      . c++-mode)
                ("\\.cpp$"     . c++-mode)
                ; closest we've got
                ("\\.idl$"     . c++-mode)

                ("\\.tex$"     . tex-mode)
                ("\\.sty$"     . tex-mode)
                ("\\.cls$"     . tex-mode)
                ("\\.bbl$"     . tex-mode)

                ("\\.bib$"     . bibtex-mode)

                ("\\.texinfo$" . texinfo-mode)

                ("\\.p[lm]$"   . perl-mode)

                ("\\.html$"    . html-mode)
		("\\.shtml$"   . html-mode)
		("\\.htm$"     . html-mode)

		("\\.sgml$"    . sgml-mode)

                ("[Mm]akefile" . makefile-mode)
                ("GNUmakefile" . makefile-mode)
                ("Imakefile"   . makefile-mode)
                ("\\.mk$"      . makefile-mode)

                ("\\.man$"     . nroff-mode)
                ("\\.[1-9]$"   . nroff-mode)
                ("\\.ms$"      . nroff-mode)

		("\\.ad[bs]$"  . ada-mode)

                ("\\.fs$"      . forth-mode)

                ("\\.java$"    . java-mode)
                )))

;;; Some stuff I grabbed from BAM that should add neat things at the
;;; top of files you write with *emacs
(defun Full-Name ()
  (or (getenv "COPYRIGHTNAME")
      (or (getenv "FULLNAME")
          (or (getenv "NAME") "(Unknown)"))))


(defun Email-Address ()
  (or (getenv "EMAILADDRESS")
      (concat (or (getenv "LOGNAME") (user-login-name))
              "@"
              (or (getenv "DOMAINNAME")
                  (or (getenv "HIDDENHOST") (system-name))))))

(defun Year () (substring (current-time-string) 20))
(defun Month () (substring (current-time-string) 4 7))
(defun Day () (substring (current-time-string) 8 10))

(defun Update-Timestamp ()
  "Updates a file timestamp before writing.  Only the first 2048 and
   last 256 bytes are checked, and the string must be in a very specific
   format.  This is so that only the actual timestamp is changed."
  (interactive)
  (let ((current (point)))
    ; Standard timestamp update
    (goto-char (point-min))
    (if (re-search-forward
         "^\\(..?.?.? Revised: \\).*[0-9][0-9][0-9][0-9].*$" 2048 t)
        (replace-match (concat
                        "\\1"
                        (current-time-string)
                        " by "
                        (Email-Address)) t))
    ; For LaTeX
    (goto-char (point-min))
    (if (re-search-forward "\\(\\\\def\\\\FileRevised{\\)[^{]*}" 2048 t)
        (replace-match (concat
                        "\\1"
                        (current-time-string)
                        "}" ) t))
    ; For backward compatibility
    (goto-char (point-min))
    (if (re-search-forward "[ ]Modified: .*[0-9][0-9][0-9][0-9].*$" 2048 t)
        (replace-match (concat
                        " Revised: "
                        (current-time-string)
                        " by "
                        (Email-Address)) t))
    ; For those damn html pages
    (goto-char (point-max))
    (if (re-search-backward
         "^\\(..?.?.? Revised: \\).*[0-9][0-9][0-9][0-9].*$"
         (- (point-max) 256)
         t)
        (replace-match (concat
                        "\\1"
                        (current-time-string)
                        " by "
                        (Email-Address)) t))
    (goto-char current))
  nil
)

(defun Std-Header (filename f m l)
  (insert f "\n"
          m filename "\n"
          m "Created: " (current-time-string) " by " (Email-Address) "\n"
          m "Revised: " (current-time-string) " (pending)\n"
          m "Copyright " (Year) " " (Full-Name) " (" (Email-Address) ")\n"
          m "This program comes with ABSOLUTELY NO WARRANTY.\n"
	  m "$" "Id" "$\n")
  (if (not (string-equal m l)) (insert m "\n"))
  (insert l "\n")
  (insert "\n" f "EOF " filename l)
  (goto-char (point-min))
  (end-of-line))

(defun License-Program ()
  (interactive)
  (let* ((current (point))
         (left (progn (beginning-of-line) (point)))
         (right (progn
                  (move-to-column 1 t)
                  (if (not (search-forward " " (search-forward "\n" nil t) t))
                      (progn (goto-char current)
                             (move-to-column 1 t)
                             (end-of-line)
                             (insert " ")))
                  (point)))
         (m (buffer-substring left right)))
    (beginning-of-line)
    (insert
m "\n"
m "Redistribution and use in source and binary forms, with or without\n"
m "modification, are permitted provided that the following conditions are\n"
m "met:\n"
m "   1. Redistributions of source code must retain the above copyright\n"
m "      notice, this list of conditions and the following disclaimer.\n"
m "   2. Redistributions in binary form must reproduce the above copyright\n"
m "      notice, this list of conditions and the following disclaimer in\n"
m "      the documentation and/or other materials provided with the\n"
m "      distribution.  (Accompanying source code, or an offer for such\n"
m "      source code as described in the GNU General Public License, is\n"
m "      sufficient to meet this condition.)\n"
m "\n"
m "THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED\n"
m "WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF\n"
m "MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN\n"
m "NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,\n"
m "INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES\n"
m "(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR\n"
m "SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)\n"
m "HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,\n"
m "STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN\n"
m "ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE\n"
m "POSSIBILITY OF SUCH DAMAGE.\n")
    (goto-char current)
    (beginning-of-line)
    ))

(defun Gpl-Program ()
  (interactive)
  (let* ((current (point))
         (left (progn (beginning-of-line) (point)))
         (right (progn
                  (move-to-column 1 t)
                  (if (not (search-forward " " (search-forward "\n" nil t) t))
                      (progn (goto-char current)
                             (move-to-column 1 t)
                             (end-of-line)
                             (insert " ")))
                  (point)))
         (m (buffer-substring left right)))
    (beginning-of-line)
    (insert
m "\n"
m "This program is free software; you can redistribute it and/or modify it\n"
m "under the terms of the GNU General Public License as published by the\n"
m "Free Software Foundation; either version 1, or (at your option) any\n"
m "later version.\n"
m "\n"
m "This program is distributed in the hope that it will be useful, but\n"
m "WITHOUT ANY WARRANTY; without even the implied warranty of\n"
m "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n"
m "General Public License for more details.\n"
m "\n"
m "You should have received a copy of the GNU General Public License along\n"
m "with this program; if not, write to the Free Software Foundation, Inc.,\n"
m "675 Mass Ave, Cambridge, MA 02139, USA.\n")
    (goto-char current)
    (beginning-of-line)
    ))

(defun Gpl-Library ()
  (interactive)
  (let* ((current (point))
         (left (progn (beginning-of-line) (point)))
         (right (progn
                  (move-to-column 1 t)
                  (if (not (search-forward " " (search-forward "\n" nil t) t))
                      (progn (goto-char current)
                             (move-to-column 1 t)
                             (end-of-line)
                             (insert " ")))
                  (point)))
         (m (buffer-substring left right)))
    (beginning-of-line)
    (insert
m "\n"
m "This library is free software; you can redistribute it and/or modify it\n"
m "under the terms of the GNU Library General Public License as published\n"
m "by the Free Software Foundation; either version 2 of the License, or (at\n"
m "your option) any later version.\n"
m "\n"
m "This library is distributed in the hope that it will be useful, but\n"
m "WITHOUT ANY WARRANTY; without even the implied warranty of\n"
m "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n"
m "Library General Public License for more details.\n"
m "\n"
m "You should have received a copy of the GNU Library General Public\n"
m "License along with this library; if not, write to the Free Software\n"
m "Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n"
m "\n")
    (goto-char current)
    (beginning-of-line)
    ))

(defun C-Header (filename) (Std-Header filename "/* " " * " " */"))
(defun C++-Header (filename) (Std-Header filename "// " "// " "// "))
(defun Java-Header (filename) (Std-Header filename "// " "// " "// "))
(defun Makefile-Header (filename) (Std-Header filename "# " "# " "#"))
(defun Elisp-Header (filename) (Std-Header filename ";; " ";; " ";;"))
(defun Sh-Header (filename) (Std-Header filename "#!/bin/sh\n# " "# " "#"))
(defun Csh-Header (filename)
  (Std-Header filename "#!/bin/csh -f\n# " "# " "#"))
(defun Perl-Header (filename)
  (Std-Header filename "#!/usr/bin/perl\n# " "# " "#"))
(defun SGML-Header (filename) (Std-Header filename "<!-- " " " "-->"))

(defun TeX-Style-Header (filename)
  (insert "%\n"
          "% " filename "\n"
          "% \n"
          "% Created: " (current-time-string) " by " (Email-Address) "\n"
          "% Revised: " (current-time-string) " (pending)\n"
          "% Copyright " (Year) " " (Full-Name) " (" (Email-Address) ")\n"
          "% \n")
  (goto-char (point-min))
  (end-of-line))

(defun TeX-Header (filename)
  (TeX-Style-Header filename)
  (goto-char (point-max))
  (insert "\\def\\FileCreated{" (current-time-string) "}\n"
          "\\def\\FileRevised{" (current-time-string) "}\n")
  (goto-char (point-min))
  (end-of-line))

(defun Notes-Header (filename)
  (insert "Description: \n"
          "Name: \n"
          "Version: \n"
          "Source: \n"
          "Copyright: UNKNOWN\n"
          "Revision: $" "Revision" "$ $" "Date" "$\n"
          "\n"
          "%prep\n%setup\n\n%build\nmake\n\n%install\nmake install\n\n%files\n"
          )
  (goto-char (point-min))
  (end-of-line))

(defun Man-Header (filename)
  (let* ((p ".\\\" ")
         (m p)
         (l p))
    (insert p filename " -- \n"
            m "Created: " (current-time-string) " by " (Email-Address) "\n"
            m "Revised: " (current-time-string) " (pending)\n"
            m "Copyright " (Year) " " (Full-Name) " (" (Email-Address) ")\n"
m "\n"
m "Permission is granted to make and distribute verbatim copies of this\n"
m "manual provided the copyright notice and this permission notice are\n"
m "preserved on all copies.\n"
m "\n"
m "Permission is granted to copy and distribute modified versions of this\n"
m "manual under the conditions for verbatim copying, provided that the\n"
m "entire resulting derived work is distributed under the terms of a\n"
m "permission notice identical to this one\n"
m "\n"
m "Since the Linux kernel and libraries are constantly changing, this\n"
m "manual page may be incorrect or out-of-date.  The author(s) assume no\n"
m "responsibility for errors or omissions, or for damages resulting from\n"
m "the use of the information contained herein.  The author(s) may not\n"
m "have taken the same level of care in the production of this manual,\n"
m "which is licensed free of charge, as they might when working\n"
m "professionally.\n"
m "\n"
m "Formatted or processed versions of this manual, if unaccompanied by\n"
m "the source, must acknowledge the copyright and authors of this work.\n"
l "\n")
    (let ((dot (string-match "\\." filename)))
      (if dot (let ((name (upcase (substring filename 0 dot)))
                    (ext (substring filename (+ dot 1) nil)))
                (insert ".TH " name " " ext
                        " \"" (Day) " " (Month) " " (Year) "\""
                        " \"\" \"Linux Programmer's Manual\"\n"))
        (insert ".TH " filename "\n")))
    (insert ".SH NAME\n"
            ".SH SYNOPSIS\n"
            ".SH DESCRIPTION\n"
            ".SH FILES\n"
            ".SH \"SEE ALSO\"\n")
    (goto-char (point-min))
    (end-of-line)))

(defvar auto-header-alist '(("\\.c$"           . 'C-Header)
                            ("\\.h$"           . 'C-Header)
                            ("\\.lex$"         . 'C-Header)
                            ("\\.y$"           . 'C-Header)
                            ("\\.cc$"          . 'C++-Header)
                            ("\\.java$"        . 'Java-Header)
                            ("GNUmakefile$"    . 'Makefile-Header)
                            ("[Mm]akefile$"    . 'Makefile-Header)
                            ("[Mm]akefile.in$" . 'Makefile-Header)
                            ("\\.tex$"         . 'TeX-Header)
                            ("\\.bib$"         . 'TeX-Style-Header)
                            ("\\.sty$"         . 'TeX-Style-Header)
                            ("\\.cls$"         . 'TeX-Style-Header)
                            ("\\.[1-9]$"       . 'Man-Header)
                            ("\\.sh$"          . 'Sh-Header)
                            ("\\.csh$"         . 'Csh-Header)
                            ("\\.pl$"          . 'Perl-Header)
                            ("\\.Notes$"       . 'Notes-Header)
                            ("\\.el$"          . 'Elisp-Header)
			    ("\\.html$"	       . 'SGML-Header)
                            ))

; I used Charlie Martin's autoinsert.el as a model for this. . .
(defun auto-header ()
  "Insert default contents into a new file."
    (let ((alist auto-header-alist)
        ;; remove backup suffixes from file name
        (name (file-name-sans-versions buffer-file-name))
        (header-fun nil))

    ;; find first matching alist entry
    (while (and (not header-fun) alist)
      (if (string-match (car (car alist)) name)
          (setq header-fun (car (cdr (cdr (car alist)))))
        (setq alist (cdr alist))))

    ;; Now, if we found an appropriate insert file, insert it
    (if header-fun (apply header-fun (file-name-nondirectory name) nil))))

(defun perl-auto-header ()
  "Check for blank buffer, and insert perl-style header."
  (let ((name (file-name-sans-versions buffer-file-name)))
    (if (string-match (buffer-string (point-min) (point-max)) "")
        (apply 'Perl-Header (file-name-nondirectory name) nil))))

(add-hook 'perl-mode-hook 'perl-auto-header)

(add-hook 'find-file-not-found-hooks 'auto-header)

(defun sys-info ()
  (let ((buffer nil))
    (unwind-protect
        (save-excursion
          (setq buffer (generate-new-buffer "*sys-info-work*"))
          (set-buffer buffer)
          (call-process "uname" nil t nil "-sr")
          (buffer-substring (point-min) (- (point-max) 1))) ; remove newline
      (and buffer (kill-buffer buffer)))))

(defun sys-host ()
  (let* ((name (system-name)) (dot (string-match "\\." name)))
    (if dot (substring name 0 dot) name)))

(put 'eval-expression 'disabled nil)

(put 'upcase-region 'disabled nil)
(custom-set-variables
 '(ssl-program-name "openssl")
 '(ssl-view-certificate-program-name "openssl")
 '(toolbar-mail-commands-alist (quote ((not-configured . toolbar-not-configured) (vm . vm) (gnus . gnus-no-server) (rmail . rmail) (mh . mh-rmail) (pine toolbar-external "xterm" "-e" "pine") (elm toolbar-external "xterm" "-e" "elm") (mutt toolbar-external "rxvt" "-fn" "12x24" "-e" "mutt") (exmh toolbar-external "exmh") (netscape toolbar-external "netscape" "mailbox:") (send . mail))))
 '(gnuserv-program (concat exec-directory "/gnuserv"))
 '(c-default-style "stroustrup")
 '(toolbar-news-reader (quote gnus))
 '(toolbar-mail-reader (quote mutt))
 '(nnmail-spool-file "/var/spool/mail/$user")
 '(c-basic-offset 4)
 '(gnus-select-method (quote (nntp (getenv "NNTPSERVER"))))
 '(user-mail-address (getenv "EMAILADDRESS") t)
 '(query-user-mail-address nil)
 '(ssl-program-arguments (quote ("s_client" "-host" host "-port" service "-verify" (int-to-string ssl-certificate-verification-policy) "-CApath" ssl-certificate-directory)))
 '(ssl-view-certificate-program-arguments (quote ("x509" "-text" "-inform" "DER"))))
(custom-set-faces)

(if (and (string-match "XEmacs" emacs-version) running-xemacs)
    (progn
      (require 'func-menu)
      (setq fume-display-in-modeline-p t)
      (setq fume-max-items 40
            fume-fn-window-position 3
            fume-auto-position-popup t
            fume-menubar-menu-location "File"
            fume-buffer-name "*Function List*"
            fume-no-prompt-on-valid-default nil)
      (define-key global-map "\C-cl" 'fume-list-functions)
      (define-key global-map "\C-cg" 'fume-prompt-function-goto)

      (if (and (eq window-system 'x) (x-display-color-p))
	  ;; function menu
	  (progn
	    (add-hook 'find-file-hooks 'fume-add-menubar-entry)
	    ;(define-key global-map 'f8 'function-menu)
	    (define-key global-map '(control button3) 'mouse-function-menu)
	    ))
      ))

;; Options Menu Settings
;; =====================
(cond
 ((and (string-match "XEmacs" emacs-version)
       (boundp 'emacs-major-version)
       (or (and
            (= emacs-major-version 19)
            (>= emacs-minor-version 14))
           (= emacs-major-version 20))
       (fboundp 'load-options-file))
  (load-options-file "$HOME/.xemacs-options")))
;; ============================
;; End of Options Menu Settings

(setq minibuffer-max-depth nil)
(setq write-file-hooks                '(Update-Timestamp))

;; EOF emacs
