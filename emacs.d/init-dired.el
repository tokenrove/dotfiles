(require 'dired-x)

(use-package dired-rainbow)

(defun dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(defun dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(bind-keys
 :map dired-mode-map
 ([remap beginning-of-buffer] . dired-back-to-top)
 ([remap end-of-buffer] . dired-jump-to-bottom))
