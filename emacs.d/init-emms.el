(require 'emms-setup)
(require 'emms-player-mpd)
(emms-standard)

(setq emms-player-mpd-server-name "localhost"
      emms-player-mpd-server-port "6600"
      emms-player-mpd-music-directory "/var/lib/mpd/music")
(add-to-list 'emms-info-functions 'emms-info-mpd)
(add-to-list 'emms-player-list 'emms-player-mpd)
(emms-player-mpd-connect)

(require 'emms-playing-time)
(require 'emms-playlist-mode)
(require 'emms-mode-line-icon)
(emms-mode-line 1)
(emms-playing-time 1)

(global-set-key (kbd "<XF86AudioPlay>") 'emms-pause)
(global-set-key (kbd "<XF86AudioStop>") 'emms-stop)
(global-set-key (kbd "<XF86AudioPrev>") 'emms-previous)
(global-set-key (kbd "<XF86AudioNext>") 'emms-next)
