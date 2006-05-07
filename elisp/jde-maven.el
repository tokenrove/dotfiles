<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html><head><title>EmacsWiki: jde-maven.el</title><link type="text/css" rel="stylesheet" href="/emacs/wiki.css" /><meta name="robots" content="INDEX,NOFOLLOW" /><link rel="alternate" type="application/rss+xml" title="Emacs Wiki with page content" href="http://www.emacswiki.org/cgi-bin/wiki?action=rss;full=1" /><link rel="alternate" type="application/rss+xml" title="Emacs Wiki with page content and diff" href="http://www.emacswiki.org/cgi-bin/wiki?action=rss;full=1;diff=1" /><link rel="alternate" type="application/rss+xml" title="Emacs Wiki including minor differences" href="http://www.emacswiki.org/cgi-bin/wiki?action=rss;showedit=1" /></head><body class="http://www.emacswiki.org/cgi-bin/emacs"><div class="header"><a class="logo" href="http://www.emacswiki.org/cgi-bin/emacs/SiteMap"><img class="logo" src="/emacs_logo.png" alt="[Home]" /></a><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/Suggestions">Suggestions</a> </span><form class="tiny" action="http://www.emacswiki.org/cgi-bin/emacs"><p>Search: <input type="text" name="search" size="20" /></p></form><h1><a title="Click to search for references to this page" href="http://www.emacswiki.org/cgi-bin/emacs?search=jde-maven.el">jde-maven.el</a></h1></div><div class="content browse"><p><p><a href="http://www.emacswiki.org/cgi-bin/emacs/download/jde-maven.el">Download</a></p><pre class="source"><pre class="code"><span class="linecomment">;;; jde-maven.el --- Use Apache Maven to build your JDE projects</span>

<span class="linecomment">;; $Id: jde-maven.el,v 1.1 2005/11/11 20:29:18 cplate Exp cplate $</span>

<span class="linecomment">;;</span>
<span class="linecomment">;; Author: Raffael Herzog &lt;herzog@raffael.ch&gt;</span>
<span class="linecomment">;; Created: 30 Apr 2004</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Updated by Christian Plate &lt;cplate@web.de&gt; to work with</span>
<span class="linecomment">;; CVS Emacs 22.0.50</span>
<span class="linecomment">;; Version 0.1.2</span>

<span class="linecomment">;; This file is not part of Emacs</span>

<span class="linecomment">;; This program is free software; you can redistribute it and/or</span>
<span class="linecomment">;; modify it under the terms of the GNU General Public License as</span>
<span class="linecomment">;; published by the Free Software Foundation; either version 2, or (at</span>
<span class="linecomment">;; your option) any later version.</span>

<span class="linecomment">;; This program is distributed in the hope that it will be useful, but</span>
<span class="linecomment">;; WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="linecomment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU</span>
<span class="linecomment">;; General Public License for more details.</span>

<span class="linecomment">;; You should have received a copy of the GNU General Public License</span>
<span class="linecomment">;; along with this program; see the file COPYING.  If not, write to</span>
<span class="linecomment">;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,</span>
<span class="linecomment">;; Boston, MA 02111-1307, USA.</span>

<span class="linecomment">;; Commentary:</span>

<span class="linecomment">;; This file provides functions to control the Maven console from</span>
<span class="linecomment">;; within Emacs and to use Maven for building Java either by calling</span>
<span class="linecomment">;; it for each build separately or using the Maven console.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; It's designed to be used in conjunction with JDEE.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; To install put this file somewhere in your load-path, byte-compile</span>
<span class="linecomment">;; it and add a (require 'jde-maven) to your .emacs *after* JDEE has</span>
<span class="linecomment">;; been loaded.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; See the customization group jde-maven for customization options.</span>
<span class="linecomment">;; See the description of the command jde-maven-console-build for</span>
<span class="linecomment">;; information on what it does.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This provides the following interactive commands:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -- jde-maven-build: Build without using the console.</span>
<span class="linecomment">;; -- jde-maven-console-build: Build using the console.</span>
<span class="linecomment">;; -- jde-maven-console-start: Start the console.</span>
<span class="linecomment">;; -- jde-maven-console-stop: Stop the console.</span>
<span class="linecomment">;; -- jde-maven-console-force-stop: Kill the console.</span>
<span class="linecomment">;; -- jde-maven-console-restart: Restart the console.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Thanks to Jason Stell and Kevin A. Burton for jde-ant.el.</span>
<span class="linecomment">;; jde-maven-console-build-internal is heavily based on their code,</span>
<span class="linecomment">;; although not much of the original function is left ... :)</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; TODO:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -- Support more than one console running. Basic idea: Use one</span>
<span class="linecomment">;;    console for each project file. Allow a maximum number of</span>
<span class="linecomment">;;    consoles to be running concurrently. If this number is exceeded,</span>
<span class="linecomment">;;    stop the least recently used one.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -- Automatic detection when the console needs to be restarted.</span>
<span class="linecomment">;;    Check the timestamps of project.xml, maven.xml,</span>
<span class="linecomment">;;    project.properties and build.properties. Question: What about</span>
<span class="linecomment">;;    reactor?</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -- Is there a way to determine whether the build failed or</span>
<span class="linecomment">;;    succeeded?</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -- Completion in the goal prompt.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; History:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -- Version 0.1 (9 May 2004)</span>
<span class="linecomment">;;    Initial Version</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>

(defgroup jde-maven nil
  "<span class="quote">Build using maven.</span>"
  :group 'jde
  :prefix 'jde-maven)
(defcustom jde-maven-command "<span class="quote">maven</span>"
  "<span class="quote">The command to run maven</span>"
  :group 'jde-maven
  :type 'string)
(defcustom jde-maven-project-file-name "<span class="quote">project.xml</span>"
  "<span class="quote">The name of the maven project file.</span>"
  :group 'jde-maven
  :type '(choice (const :tag "<span class="quote">Default</span>" "<span class="quote">project.xml</span>")
                 (string :tag "<span class="quote">String</span>")))
(defcustom jde-maven-prompt-project-file nil
  "<span class="quote">Prompt for the project file? If this is nil, jde-maven will look
  for the next project file the directory tree up the current file.
  The name of the project file can be customized in
  `jde-maven-project-file-name'.</span>"
  :group 'jde-maven
  :type '(choice (const :tag "<span class="quote">No</span>" nil)
                 (const :tag "<span class="quote">Yes</span>" t)))
(defcustom jde-maven-goal nil
  "<span class="quote">The name of the goal to attain.</span>"
  :group 'jde-maven
  :type '(choice (const :tag "<span class="quote">Default</span>" nil)
                 (string :tag "<span class="quote">String</span>")))
(defcustom jde-maven-prompt-goal t
  "<span class="quote">Prompt for the goal to attain?</span>"
  :group 'jde-maven
  :type '(choice (const :tag "<span class="quote">No</span>" nil)
                 (const :tag "<span class="quote">Yes</span>" t)))
(defcustom jde-maven-arguments "<span class="quote"></span>"
  "<span class="quote">The arguments to be passed to maven.</span>"
  :group 'jde-maven
  :type 'string)
(defcustom jde-maven-prompt-arguments nil
  "<span class="quote">Prompt for further maven arguments?</span>"
  :group 'jde-maven
  :type '(choice (const :tag "<span class="quote">No</span>" nil)
                 (const :tag "<span class="quote">Yes</span>" t)))
(defcustom jde-maven-console-goal "<span class="quote">console</span>"
  "<span class="quote">The goal used to start the Maven console.</span>"
  :group 'jde-maven
  :type 'string)
(defcustom jde-maven-console-prompt-regex "<span class="quote">^[-a-zA-Z0-9.:_/ \\t]+ &gt;\\( \\[[-a-zA-Z0-9.:_/]*\\]\\)?$</span>"
  "<span class="quote">The regex for the Maven console prompt.</span>"
  :group 'jde-maven
  :type 'string)
(defcustom jde-maven-console-timeout 10
  "<span class="quote">The timeout when waiting for output of the maven console.</span>"
  :group 'jde-maven
  :type 'integer)


<span class="linecomment">;;</span>
<span class="linecomment">;; define some variables</span>
<span class="linecomment">;;</span>

(defvar jde-maven-project-file-history nil
  "<span class="quote">The project file history.</span>")
(defvar jde-maven-current-project-file nil
  "<span class="quote">The project file last use for normal compilation or the currently running Maven process.</span>")
(defvar jde-maven-goal-history nil
  "<span class="quote">History of goals.</span>")
(defvar jde-maven-arguments-history nil
  "<span class="quote">History of Maven arguments.</span>")

(defvar jde-maven-console-process nil
  "<span class="quote">The currently running Maven console process</span>")

(defvar jde-maven-console-status 'not-running
  "<span class="quote">The current status of the console. Possible values are:
`starting': The console is just starting
`ready': The console is ready to accept commands
`working': The console is currently building one or more goals
`exiting': The console is exiting
`not-running': The console is not running</span>")

(defvar jde-maven-console-current-line "<span class="quote"></span>"
  "<span class="quote">The process filter is line-oriented, i.e. it writes what it
receives into this variable until a line is complete. Complete lines
are then logged, if the status is `working' inserted into the
compilation buffer.</span>")



<span class="linecomment">;;</span>
<span class="linecomment">;; some constants</span>
<span class="linecomment">;;</span>

(defconst jde-maven-console-process-name "<span class="quote">Maven</span>"
  "<span class="quote">The name of the Maven process.</span>")
(defconst jde-maven-console-log-buffer-name "<span class="quote">*Maven*</span>"
  "<span class="quote">The name of the buffer containing the Maven log.</span>")
(defconst jde-maven-console-compilation-buffer-name "<span class="quote">*compilation*</span>"
  "<span class="quote">The name of the compilation buffer to use.</span>")



<span class="linecomment">;;</span>
<span class="linecomment">;; generic functions for jde-maven</span>
<span class="linecomment">;;</span>

(defun jde-maven-get-project-file()
  "<span class="quote">Determine the path to the project file according to the user's
preferences. It either prompts for a project file if
`jde-maven-prompt-project-file' is t, or it searches for a file
called `jde-maven-projecct-file-name' the directory tree upwards
from the current file.</span>"
  (let ((project-file nil))
    (setq project-file
          (if jde-maven-prompt-project-file
              (read-file-name "<span class="quote">Project File: </span>" jde-maven-current-project-file jde-maven-current-project-file t)
            (catch 'found
              (let ((last-directory nil))
                (setq project-file (file-name-directory (buffer-file-name)))
                (while (not (string= last-directory project-file))
                  (message (concat project-file jde-maven-project-file-name))
                  (when (file-regular-p (concat project-file jde-maven-project-file-name))
                    (throw 'found (concat project-file jde-maven-project-file-name)))
                  (setq last-directory project-file)
                  (setq project-file (file-name-directory (directory-file-name project-file))))
                (error (concat "<span class="quote">No </span>" jde-maven-project-file-name "<span class="quote"> found.</span>"))))))
    (setq project-file (expand-file-name project-file))
    <span class="linecomment">;;(setq jde-maven-current-project-file project-file)</span>
    (setq project-file (if (file-directory-p project-file)
                           (concat (file-name-as-directory project-file) jde-maven-project-file-name)
                         project-file))
    (if (not (file-regular-p project-file))
        (error (concat project-file "<span class="quote"> does not exist or is not a regular file</span>")))
    project-file))

(defun jde-maven-get-goal()
  "<span class="quote">Get the goal to build. Prompt for a goal if `jde-maven-prompt-goal'
is t or use the value of `jde-maven-goal'</span>"
  (if jde-maven-prompt-goal
      (read-string "<span class="quote">Goal: </span>" (if jde-maven-goal-history
                                (car jde-maven-goal-history)
                              jde-maven-goal)
                   '(jde-maven-goal-history . 1))
    jde-maven-goal))

(defun jde-maven-get-arguments()
  "<span class="quote">Get the arguments to run Maven with. Prompts for arguemtns if
`jde-maven-prompt-arguments' is t or uses `jde-maven-arguments'.</span>"
  (if jde-maven-prompt-arguments
      (read-string "<span class="quote">Arguments: </span>" (if jde-maven-arguments-history
                                     (car jde-maven-arguments-history)
                                   jde-maven-arguments)
                   '(jde-maven-arguments-history . 1))
    jde-maven-arguments))

(defun jde-maven-build-command-line(project-file goal arguments)
  "<span class="quote">Build a Maven command line.</span>"
  (concat "<span class="quote">cd \</span>""<span class="quote"> (file-name-directory project-file)
          </span>"\"<span class="quote"> && </span>" jde-maven-command "<span class="quote"> -f </span>" (file-name-nondirectory project-file)
          "<span class="quote"> </span>" arguments "<span class="quote"> </span>" goal))



<span class="linecomment">;;</span>
<span class="linecomment">;; do a Maven build without using the console</span>
<span class="linecomment">;;</span>

(defun jde-maven-build (&optional project-file goal args)
  "<span class="quote">Do a standard maven build. Consider using the console ... :)</span>"
  (interactive)
  (compile (jde-maven-build-command-line (if project-file
                                             project-file
                                           (jde-maven-get-project-file))
                                         (if goal
                                             goal
                                           (jde-maven-get-goal))
                                         (if args
                                             args
                                           (jde-maven-get-arguments)))))


<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;; Console</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>

<span class="linecomment">;;</span>
<span class="linecomment">;; Utilities</span>
<span class="linecomment">;;</span>

(defun jde-maven-console-running-p ()
  "<span class="quote">Return t if the console is currently running, nil otherwise.</span>"
  (let ((status (process-status jde-maven-console-process-name)))
    (if status
        (if (string= (symbol-name status) "<span class="quote">exit</span>")
            (progn
              (delete-process jde-maven-console-process-name)
              nil)
          t)
      nil)))

(defun jde-maven-console-get-log-buffer ()
  "<span class="quote">Get the current maven log buffer or create a new one, if it doesn't
exist.</span>"
  (let ((buf (get-buffer jde-maven-console-log-buffer-name)))
    (if buf
        buf
      (setq buf (generate-new-buffer jde-maven-console-log-buffer-name))
      (with-current-buffer buf
        (setq buffer-read-only nil)
        (buffer-disable-undo))
      buf)))

(defun jde-maven-console-wait-for-status (status)
  "<span class="quote">Wait for the console to enter the specified status. See the
description of the variable `jde-maven-console-status' for possible
states.</span>"
  (if (not (jde-maven-console-running-p))
      (error "<span class="quote">Maven console not running</span>"))
  (let ((old-status jde-maven-console-status))
    (if (not (string= (symbol-name old-status)
                      (symbol-name status)))
        (while (string= (symbol-name jde-maven-console-status)
                        (symbol-name old-status))
          (if (not (jde-maven-console-running-p))
              <span class="linecomment">;; If not running, set old-status to whatever and exit</span>
              (setq old-status 'dummy-status-not-possible)
            (accept-process-output (get-process jde-maven-console-process-name) jde-maven-console-timeout)))))
  (string= (symbol-name jde-maven-console-status)
           (symbol-name status)))

(defun jde-maven-console-send-command (command &optional new-status)
  "<span class="quote">Send a command to the console optionally setting the status to
new-status afterwards. This functions waits for the console to be in
the state `ready' before sending the command.</span>"
  (if (not (jde-maven-console-running-p))
      (error "<span class="quote">Maven console not running</span>"))
  (message "<span class="quote">Waiting for console to be ready to accept commands...</span>")
  (jde-maven-console-wait-for-status 'ready)
  (if new-status (jde-maven-console-set-status new-status))
  (jde-maven-console-log (concat command "<span class="quote">\n</span>"))
  (message (concat "<span class="quote">Sending command: </span>" command))
  (process-send-string jde-maven-console-process-name (concat command "<span class="quote">\n</span>")))

(defun jde-maven-console-log (message)
  "<span class="quote">Log message to the console.</span>"
  (with-current-buffer (jde-maven-console-get-log-buffer)
    (goto-char (point-max))
    (insert message)
    (set-buffer-modified-p nil)))

(defun jde-maven-console-log-to-compilation-buffer (message)
  "<span class="quote">Log message to the compilation buffer.</span>"
  (with-current-buffer (get-buffer jde-maven-console-compilation-buffer-name)
    (goto-char (point-max))
    (if message
        (insert message)
      (newline))
    (if (not jde-xemacsp)
        (if compilation-scroll-output
            (let ((win (get-buffer-window "<span class="quote">*compilation*</span>")))
              (save-selected-window
                (if win
                    (progn
                      (select-window win)
                      (goto-char (point-max))))))))))

(defun jde-maven-console-set-status (status)
  "<span class="quote">Set the current status of the console. For internal use only.</span>"
  (when (not (string= (symbol-name jde-maven-console-status)
                      (symbol-name status)))
    (setq jde-maven-console-status status)))


<span class="linecomment">;;</span>
<span class="linecomment">;; process communication stuff</span>
<span class="linecomment">;;</span>

(defun jde-maven-console-filter (process string)
  "<span class="quote">The process filter for the console. This basically forwards
everything to the maven log buffer. While in status `working', it
additionally appends things to the compilation buffer. Detects the
prompt and sets the status to `ready'.</span>"
  (mapc (lambda (x)
          (if (= x ?\n)
              (progn
                (jde-maven-console-log (concat jde-maven-console-current-line "<span class="quote">\n</span>"))
                (if (string-match jde-maven-console-prompt-regex jde-maven-console-current-line)
                    (progn
                      (if (string= (symbol-name jde-maven-console-status) "<span class="quote">working</span>")
                          (jde-maven-console-log-to-compilation-buffer
                           (concat "<span class="quote">\n\nCompilation finished at </span>" (current-time-string) "<span class="quote">\n</span>")))
                      (jde-maven-console-set-status 'ready))
                  (when (and (not (string= (symbol-name jde-maven-console-status) "<span class="quote">starting</span>"))
                             (not (string= (symbol-name jde-maven-console-status) "<span class="quote">exiting</span>")))
                    (jde-maven-console-set-status 'working)
                    (jde-maven-console-log-to-compilation-buffer
                     (concat jde-maven-console-current-line "<span class="quote">\n</span>"))))
                (sit-for 0)
                (setq jde-maven-console-current-line "<span class="quote"></span>"))
            (setq jde-maven-console-current-line (concat jde-maven-console-current-line (char-to-string x)))))
  string))

(defun jde-maven-console-sentinel (process string)
  "<span class="quote">The process sentinel for the console. This one simply sets the
status to `not-running'</span>"
  (jde-maven-console-log (concat "<span class="quote">Maven Sentinel: </span>" string "<span class="quote">\n</span>"))
  <span class="linecomment">;; I think, we can safely assume that whenever this function is called,</span>
  <span class="linecomment">;; Maven exited for whatever reason</span>
  (jde-maven-console-set-status 'not-running))



<span class="linecomment">;;</span>
<span class="linecomment">;; starting/stopping the console and building</span>
<span class="linecomment">;;</span>

(defun jde-maven-console-start (&optional project-file args)
  "<span class="quote">Start the maven console with the given project file and arguments.</span>"
  (interactive)
  (if (jde-maven-console-running-p)
      (error "<span class="quote">Maven console already running</span>"))
  (message "<span class="quote">Starting Maven console...</span>")
  (let ((process-connection-type nil)
        (console nil))
    (jde-maven-console-set-status 'starting)
    (with-current-buffer (jde-maven-console-get-log-buffer)
      (erase-buffer)
      (set-buffer-modified-p nil))

    (insert (jde-maven-build-command-line (if project-file
                                                                         project-file
                                                                       (jde-maven-get-project-file))
                                                                     jde-maven-console-goal
                                                                     (if args
                                                                         args
                                                                       (jde-maven-get-arguments))))
    (setq console
          (start-process-shell-command jde-maven-console-process-name
                                       jde-maven-console-log-buffer-name
                                       (jde-maven-build-command-line (if project-file
                                                                         project-file
                                                                       (jde-maven-get-project-file))
                                                                     jde-maven-console-goal
                                                                     (if args
                                                                         args
                                                                       (jde-maven-get-arguments)))))
    (set-process-filter console 'jde-maven-console-filter)
    (set-process-sentinel console 'jde-maven-console-sentinel)
    (if (jde-maven-console-wait-for-status 'ready)
        (message "<span class="quote">Maven console started</span>")
      (error "<span class="quote">Starting Maven failed</span>"))))

(defun jde-maven-console-stop ()
  "<span class="quote">Stop an already running maven console.</span>"
  (interactive)
  (if (jde-maven-console-running-p)
      (progn
        (message "<span class="quote">Stopping maven console...</span>")
        (jde-maven-console-send-command "<span class="quote">quit</span>" 'exiting)
        (jde-maven-console-wait-for-status 'not-running)
        (if (jde-maven-console-running-p)
            (error "<span class="quote">Error stopping Maven console</span>")
          (message "<span class="quote">Maven console stopped</span>")))
    (error "<span class="quote">Console not running</span>")))

(defun jde-maven-console-force-stop ()
  "<span class="quote">Kill a running maven console.</span>"
  (interactive)
  (if (jde-maven-console-running-p)
      (kill-process (get-process jde-maven-console-process-name))))

(defun jde-maven-console-restart ()
  "<span class="quote">Resteart a running maven console.</span>"
  (interactive)
  (if (jde-maven-console-running-p)
      (jde-maven-console-stop))
  (jde-maven-console-start))

<span class="linecomment">;; Thanks to Jack Donohue &lt;donohuej@synovation.com&gt;.</span>
(defun jde-maven-finish-kill-buffer (buf msg)
  "<span class="quote">Removes the jde-compile window after a few seconds if no errors.</span>"
  (save-excursion
    (set-buffer buf)
    (if (null (or (string-match "<span class="quote">.*exited abnormally.*</span>" msg)
                  (string-match "<span class="quote">.*BUILD FAILED.*</span>" (buffer-string))))
        <span class="linecomment">;;no errors, make the compilation window go away in a few seconds</span>
        (lexical-let ((compile-buffer buf))
          (run-at-time
           "<span class="quote">2 sec</span>" nil 'jde-compile-kill-buffer
           compile-buffer)
          (message "<span class="quote">No compilation errors</span>"))
      <span class="linecomment">;;there were errors, so jump to the first error</span>
      <span class="linecomment">;;(if jde-compile-jump-to-first-error (next-error 1)))))</span>
      )))

(defun jde-maven-console-build (&optional restart)
  "<span class="quote">Do a build using the console. With prefix argument, stop the
current console before building even if the project file is still the
same.

This command will restart the console as needed. It keeps track of
which project file the current console is running. If the project file
to be used didn't change, it reuses the current console, else it stops
it (if running) and starts a new one for the new project file.</span>"
  (interactive "<span class="quote">P</span>")
  (if (and restart (jde-maven-console-running-p))
      (jde-maven-console-stop))
  (let (project-file goal args)
    (setq project-file (jde-maven-get-project-file))
    (setq goal (jde-maven-get-goal))
    (if (and (not (string= jde-maven-current-project-file project-file))
             (jde-maven-console-running-p))
        (jde-maven-console-stop))
    (setq jde-maven-current-project-file project-file)
    (when (not (jde-maven-console-running-p))
      (setq args (jde-maven-get-arguments))
      (jde-maven-console-start project-file args))
    (jde-maven-console-build-internal project-file goal)))

(defun jde-maven-console-build-internal (project-file goal)
  "<span class="quote">This method displays Maven output in a compilation buffer.</span>"
  (let* (error-regexp-alist
         enter-regexp-alist
         leave-regexp-alist
         file-regexp-alist
         nomessage-regexp-alist
         (parser compilation-parse-errors-function)
         outbuf)

    (save-excursion
      (setq outbuf (get-buffer-create jde-maven-console-compilation-buffer-name))
      (set-buffer outbuf)

      <span class="linecomment">;; In case the compilation buffer is current, make sure we get the global</span>
      <span class="linecomment">;; values of compilation-error-regexp-alist, etc.</span>
      (kill-all-local-variables))
    (setq error-regexp-alist compilation-error-regexp-alist)
    (setq enter-regexp-alist
          (if (not jde-xemacsp) compilation-enter-directory-regexp-alist))
    (setq leave-regexp-alist
          (if (not jde-xemacsp) compilation-leave-directory-regexp-alist))
    (setq file-regexp-alist
          (if (not jde-xemacsp) compilation-file-regexp-alist))
    (setq nomessage-regexp-alist
          (if (not jde-xemacsp) compilation-nomessage-regexp-alist))

    (save-excursion
      <span class="linecomment">;; Clear out the compilation buffer and make it writable.</span>
      (set-buffer outbuf)
      (compilation-mode)
      (setq buffer-read-only nil)
      (buffer-disable-undo (current-buffer))
      (erase-buffer)
      (buffer-enable-undo (current-buffer))
      (display-buffer outbuf)
      (insert "<span class="quote">Maven build\n</span>")
      (insert "<span class="quote">~~~~~~~~~~~\n</span>")
      (insert (concat "<span class="quote">Project file : </span>" project-file "<span class="quote">\n</span>"))
      (insert (concat "<span class="quote">Building goal: </span>" goal "<span class="quote">\n\n</span>"))
      (set-buffer-modified-p nil))
    (setq outwin (display-buffer outbuf))
    (save-excursion
      (set-buffer outbuf)
      <span class="linecomment">;; (setq buffer-read-only t)  ;;; Non-ergonomic.</span>
      (set (make-local-variable 'compilation-parse-errors-function)
           parser)
      <span class="linecomment">;; What's that?</span>
      <span class="linecomment">;;(set (make-local-variable 'compilation-error-message)</span>
      <span class="linecomment">;;     error-message)</span>
      (set (make-local-variable 'compilation-error-regexp-alist)
           error-regexp-alist)
      (if (not jde-xemacsp)
          (progn
            (set (make-local-variable
                  'compilation-enter-directory-regexp-alist)
                 enter-regexp-alist)
            (set (make-local-variable
                  'compilation-leave-directory-regexp-alist)
                 leave-regexp-alist)
            (set (make-local-variable 'compilation-file-regexp-alist)
                 file-regexp-alist)
            (set (make-local-variable
                  'compilation-nomessage-regexp-alist)
                 nomessage-regexp-alist)))
      (setq default-directory (file-name-directory project-file)
            compilation-directory-stack (list default-directory))
      (compilation-set-window-height outwin)

      <span class="linecomment">;;(jde-maven-console-set-status 'building)</span>
      (jde-maven-console-send-command goal 'working)

      (if (not jde-xemacsp)
          (if compilation-process-setup-function
              (funcall compilation-process-setup-function))))
    <span class="linecomment">;; Make it so the next C-x ` will use this buffer.</span>
    (setq compilation-last-buffer outbuf)

    (if (jde-maven-console-wait-for-status 'ready)
	<span class="linecomment">;; If no error kill the buffer</span>
	(jde-maven-finish-kill-buffer outbuf "<span class="quote">Compilation finished sucessfully.</span>")
      )))

(provide 'jde-maven)</pre></pre></p></div><div class="footer"><hr /><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/cgi-bin/emacs/Suggestions">Suggestions</a> </span><span class="edit bar"><br /> <a class="edit" accesskey="e" title="Click to edit this page" href="http://www.emacswiki.org/cgi-bin/emacs?action=edit;id=jde-maven.el">Edit this page</a> <a class="history" href="http://www.emacswiki.org/cgi-bin/emacs?action=history;id=jde-maven.el">View other revisions</a> <a class="admin" href="http://www.emacswiki.org/cgi-bin/emacs?action=admin;id=jde-maven.el">Administration</a></span><span class="time"><br /> Last edited 2006-05-03 14:11 UTC by 208.0.121.20 <a class="diff" href="http://www.emacswiki.org/cgi-bin/emacs?action=browse;diff=2;id=jde-maven.el">(diff)</a></span><form method="get" action="http://www.emacswiki.org/cgi-bin/emacs" enctype="multipart/form-data" class="search">
<p><label for="search">Search:</label> <input type="text" name="search"  size="20" accesskey="f" id="search" /> <label for="searchlang">Language:</label> <input type="text" name="lang"  size="10" id="searchlang" /> <input type="submit" name="dosearch" value="Go!" /></p><div></div>
</form><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a href="http://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="http://creativecommons.org/images/public/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="http://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p>
This work is licensed to you under version 2 of the
<a href="http://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="http://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="http://creativecommons.org/">CreativeCommons</a>
<a href="http://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
</div></body></html>