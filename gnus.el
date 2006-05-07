;;;; GENERAL
(setq user-mail-address "julian@cipht.net")
(setq user-full-name "Julian Squires")
(setq gnus-use-adaptive-scoring t)
(add-hook 'message-mode-hook
	  (lambda ()
	    (setq fill-column 72)
	    (turn-on-auto-fill)))
(require 'bbdb)
(bbdb-initialize 'gnus 'message)

;;;; NEWS
(setq gnus-select-method '(nntp "news.aliant.net"))
(setq gnus-confirm-mail-reply-to-news t)

;;;; MAIL
(add-to-list 'gnus-secondary-select-methods '(nnfolder ""))
(eval-after-load "mail-source"
  '(add-to-list 'mail-sources
		'(directory :path "/home/julian/Mail/")))
;(setq send-mail-function 'smtpmail-send-it)
;(setq message-send-mail-function 'smtpmail-send-it)
;(setq smtpmail-default-smtp-server "smtp.aliant.net")

;;;; CRYPTO
(require 'pgg)
;; Always verify signatures.
(setq mm-verify-option 'always)
;; Automcatically sign when sending mails
(add-hook 'message-setup-hook 'mml-secure-message-sign-pgpmime)
;; Tells Gnus to inline the part
(eval-after-load "mm-decode"
  '(add-to-list 'mm-inlined-types "application/pgp$"))
;; Tells Gnus how to display the part when it is requested
(eval-after-load "mm-decode"
'(add-to-list 'mm-inline-media-tests '("application/pgp$"
				       mm-inline-text identity)))
;; Tell Gnus not to wait for a request, just display the thing
;; straight away.
(eval-after-load "mm-decode"
'(add-to-list 'mm-automatic-display "application/pgp$"))
;; But don't display the signatures, please.
(eval-after-load "mm-decode"
(quote (setq mm-automatic-display (remove "application/pgp-signature"
					  mm-automatic-display))))


;;;; SPAM
(require 'spam)
(spam-initialize)
