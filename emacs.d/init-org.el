;;;; ORG MODE
;; lots of this stuff stolen from: Sacha Chua, norang.ca, etc

(require 'org-agenda)
(require 'org-clock)
(require 'org-habit)
(require 'org-capture)
(require 'org-crypt)
(use-package ox-html5slide)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(global-set-key (kbd "<f12>") 'org-agenda) ; let's try this...
(global-set-key (kbd "<f11>") 'org-clock-goto) ; and this.
(setq org-log-done '(time)
      org-log-into-drawer t
      org-log-state-notes-insert-after-drawers nil
      org-extend-today-until 5          ; the day starts anew at 5am
      org-clock-persist 'history        ; was t; need to experiment -- maybe just clock?
      org-clock-idle-time 5
      org-clock-x11idle-program-name "xprintidle"
      org-x11idle-exists-p t
      org-clock-out-remove-zero-time-clocks t
      org-time-clocksum-format (quote (:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
      org-directory "~/org"
      ;; Set to the name of the file where new notes will be stored
      org-mobile-inbox-for-pull "~/org/flagged.org"
      ;; Set to <your Dropbox root directory>/MobileOrg.
      org-mobile-directory "~/Dropbox/MobileOrg"
      org-default-notes-file (concat org-directory "/refile.org")
      org-ditaa-jar-path "/usr/share/ditaa/ditaa.jar"
      org-return-follows-link t
      org-special-ctrl-a/e t
      org-special-ctrl-k t
      org-use-speed-commands t
      org-yank-adjusted-subtrees t
      org-habit-graph-column 60
      org-cycle-separator-lines 0
      org-blank-before-new-entry '((heading) (plain-list-item))
      ;; Keeps global to-do list clean
      org-agenda-todo-ignore-with-date nil ; Keep tasks with dates off the global todo lists
      org-agenda-todo-ignore-deadlines 'far ; Allow deadlines which are due soon to appear on the global todo lists
      org-agenda-todo-ignore-scheduled 'future ; Keep tasks scheduled in the future off the global todo lists
      org-agenda-skip-deadline-if-done t ; Remove completed deadline tasks from the agenda view
      org-agenda-skip-scheduled-if-done t ; Remove completed scheduled tasks from the agenda view
      org-agenda-skip-timestamp-if-done t ; Remove completed items from search results
      org-agenda-dim-blocked-tasks t
      org-agenda-window-setup 'current-window
      org-agenda-span 1)

;; don't fuck with my C-,
(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map [?\C-,] (lookup-key global-map [?\C-x]))
            (define-key global-map "\C-\M-r" 'org-capture)))

(setq org-capture-templates
      (quote (("t" "todo" entry (file org-default-notes-file)
               "* TODO %?\nSCHEDULED: %^t\n%U\n%a\n  %i" :clock-in t :clock-resume t)
              ("n" "note" entry (file org-default-notes-file)
               "* %? :NOTE:\n%U\n%a\n  %i" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org"))
               "* %?\n%U\n  %i" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file org-default-notes-file)
               "* TODO Review %c\n%U\n  %i" :immediate-finish t)
              ("p" "Phone call" entry (file org-default-notes-file)
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file org-default-notes-file)
               "* NEXT %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n  %i")
	      ("b" "Blog post" entry (file (concat org-directory "/blog.org"))
	       "* %? [\%]\n  SCHEDULED: %^t\n%U\n- If there is code:\n  - [ ] have we checked for XXX comments?\n  - [ ] have we run all tests?\n  - [ ] have we noted the build requirements?\n  - [ ] have we committed (and tagged) the release code?\n  - [ ] have we noted the licensing?\n- [ ] does the post communicate:\n  - [ ] who is the intended audience?\n- [ ] have we checked spelling and grammar in each?\n- [ ] do the links point to the correct places?\n- [ ] is there a title set?\n- [ ] are tags set and consistent with other posts?\n  %i"
	       :clock-in t :clock-resume t))
	     ))
(org-clock-persistence-insinuate)

(setq org-agenda-log-mode-items '(closed clock state)
      org-agenda-start-with-log-mode t)

(setq org-agenda-files '("~/org")
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm
      org-refile-targets '((nil :maxlevel . 4) (org-agenda-files :maxlevel . 2))
      org-refile-use-outline-path 'file)

(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "STARTED(s)" "WAITING(w@/!)" "SOMEDAY(S!)" "|" "DONE(d!/!)" "CANCELLED(c@/!)" "DELEGATED(D@/!)"))
      org-use-fast-todo-selection t
      org-todo-state-tags-triggers
      '(("CANCELLED" ("CANCELLED" . t))
	("WAITING" ("WAITING" . t))
	("SOMEDAY" ("WAITING" . t))
	("DELEGATED" ("WAITING" . t))
	(done ("WAITING"))
	("TODO" ("WAITING") ("CANCELLED"))
	("NEXT" ("WAITING"))
	("STARTED" ("WAITING"))
	("DONE" ("WAITING") ("CANCELLED"))))

(setq org-catch-invisible-edits 'show-and-error) ; Could use smart here but I think it's too risky.

(setq org-agenda-custom-commands
      '(("w" "Waiting and Postponed tasks" todo "WAITING|SOMEDAY"
	 ((org-agenda-overriding-header "Waiting Tasks")))
	("P" "Project list" ((tags "PROJECT")))
	("r" "Refile New Notes and Tasks" tags "REFILE"
	 ((org-agenda-todo-ignore-with-date nil)
	  (org-agenda-todo-ignore-deadlines nil)
	  (org-agenda-todo-ignore-scheduled nil)
	  (org-agenda-todo-ignore-timestamp nil)
	  (org-agenda-overriding-header "Tasks to Refile")))
	("n" "Next and Started tasks" tags-todo "-WAITING-CANCELLED/!NEXT|STARTED"
	 ((org-agenda-overriding-header "Next Tasks")))
	("*" "All open TODO tasks" tags-todo "-CANCELLED"
	 ((org-agenda-overriding-header "All Open TODO tasks")
	  (org-agenda-todo-ignore-with-date nil)
	  (org-agenda-todo-ignore-scheduled nil)
	  (org-agenda-todo-ignore-deadlines nil)
	  (org-agenda-todo-ignore-timestamp nil)
	  (org-agenda-todo-list-sublevels t)
	  (org-tags-match-list-sublevels 'indented)))))

;; Change task to STARTED when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-started)
(defun bh/clock-in-to-started (kw)
  "Switch task from TODO or NEXT to STARTED when clocking in.
Skips capture tasks."
  (if (and (member (org-get-todo-state) (list "TODO" "NEXT"))
           (not (and (boundp 'org-capture-mode) org-capture-mode)))
      "STARTED"))

;; columns and effort estimates
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 8:00")))
      org-columns-default-format "%60ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

(setq org-tags-exclude-from-inheritance '("PROJECT" "crypt"))

(global-set-key (kbd "<f5>") 'bh/org-todo)
(defun bh/org-todo (arg)
  (interactive "p")
  (if (equal arg 4)
      (save-restriction
        (widen)
        (org-narrow-to-subtree)
        (org-show-todo-tree nil))
    (widen)
    (org-narrow-to-subtree)
    (org-show-todo-tree nil)))

(global-set-key (kbd "<S-f5>") 'bh/widen)

(defun bh/widen ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (org-agenda-remove-restriction-lock)
    (widen)
    (org-agenda-remove-restriction-lock)))

(eval-after-load "org-crypt"
  '(progn
     ;; Encrypt all entries before saving
     (org-crypt-use-before-save-magic)
     ;; GPG key to use for encryption
     (setq org-crypt-key "0FD4092C"
	   org-crypt-disable-auto-save 'encrypt)))

(defun jump-to-org-agenda ()
  (interactive)
  (let ((buf (get-buffer "*Org Agenda*"))
	wind)
    (if buf
	(if (setq wind (get-buffer-window buf))
	    (select-window wind)
	  (if (called-interactively-p 'interactive)
	      (progn
		(select-window (display-buffer buf t t))
		(org-fit-window-to-buffer)
		;; (org-agenda-redo)
		)
	    (with-selected-window (display-buffer buf)
	      (org-fit-window-to-buffer)
	      ;; (org-agenda-redo)
	      )))
      (call-interactively 'org-agenda-list))))

(add-to-list 'org-modules 'org-habit)
(org-babel-do-load-languages
 'org-babel-load-languages
 (mapcar (lambda (x) (cons x t)) '(emacs-lisp lisp R C haskell ocaml ruby python lilypond)))
