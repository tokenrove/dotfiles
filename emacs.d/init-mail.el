;;;; BBDB

(eval-after-load "bbdb"
  ;;Tell bbdb about your email address:
  '(setq bbdb-user-mail-names
	 (regexp-opt '("julian@cipht.net"
		       "julian.squires@gmail.com"
		       "julian@miranda.org"
		       "julian@hvergelmir.com"
		       "julian@urdawell.com"
		       "tek@wiw.org"))
	 ;;cycling while completing email addresses
	 bbdb-complete-name-allow-cycling t
	 ;;No popup-buffers
	 bbdb-use-pop-up nil))

;;;; MAILCRYPT

;; Always sign encrypted messages
(eval-after-load "mailcrypt"
  '(setq mc-pgp-always-sign t))

;;;; MU4E

;; (require 'mu4e)
(require 'mml)

;; (setq mail-user-agent 'mu4e-user-agent)
(setq mail-user-agent 'gnus-user-agent)

;; default
;; (setq mu4e-maildir "~/Maildir")

(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; (See the documentation for `mu4e-sent-messages-behavior' if you have
;; additional non-Gmail addresses and want assign them different
;; behavior.)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

(setq mu4e-maildir-shortcuts
    '( ("/INBOX"               . ?i)
       ("/[Gmail].Sent Mail"   . ?s)
       ("/[Gmail].Trash"       . ?t)
       ("/[Gmail].All Mail"    . ?a)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; something about ourselves
(setq
   user-mail-address "julian@cipht.net"
   user-full-name  "Julian Squires"
   mu4e-compose-signature
    (concat
      "Julian Squires\n"))

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu

(require 'smtpmail)

;; alternatively, for emacs-24 you can use:
(setq message-send-mail-function 'smtpmail-send-it
    smtpmail-stream-type 'starttls
    smtpmail-default-smtp-server "smtp.gmail.com"
    smtpmail-smtp-server "smtp.gmail.com"
    smtpmail-smtp-service 587)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)
