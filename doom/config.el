;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Nahuel Lescano"
      user-mail-address "lescanoagustin10nahuel@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Never loose the cursor.
(beacon-mode 1)

;; Bookmarks are somewhat like registers in Vim, in that they record positions you can jump. Unlike registers, they can have
;; long names and they persist from one Emacs session to another.
(map! :leader
      (:prefix ("b". "buffer")
       :desc "Save the current bookmark to bookmark file." "w" #'bookmark-save))

;; A buffer can get out of sync with respect to its visited file on disk if that file is changed by another program.
;; To keep it up to date, you can enable Auto Revert mode by typing M-x auto-revert-mode, or you can set it to be turned on
;; globally with ‘global-auto-revert-mode’.
;; I have also turned on Global Auto Revert on non-file buffers, which is especially useful for ‘dired’ buffers.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Gives us a popup box with “Clippy, the paper clip”. The more useful functions of clippy are the two describe functions provided:
;; ‘clippy-describe-function’ and ‘clippy-describe-variable’. Hit the appropriate keybinding while the point is over a function/variable to call it.
;; A popup with helpful clippy will appear, telling you about the function/variable (using describe-function and describe-variable respectively).
(map! :leader
      (:prefix ("c h". "Help info from Clipy")
       :desc "Clippy describes function under the point" "f" #'clippy-describe-function
       :desc "Clipyy describes variable under the point" "v" #'clippy-describe-variable))

;; This setting ensures that emacsclient always opens on dashboard rather than scratch.
(setq doom-fallback-buffer-name "*dashboard*")

;; Dired is the file manager within Emacs.  Below, I setup keybindings for image previews (peep-dired).
;; Doom Emacs does not use ‘SPC d’ for any of its keybindings, so I’ve chosen the format of ‘SPC d’ plus ‘key’.
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file                            ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill   ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
 (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
(setq dired-open-extensions '(("gif" . "feh -Z -.")
                              ("jpg" . "feh -Z -.")
                              ("png" . "feh -Z -.")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

;; If peep-dired is enable, I can previews files/images while I scroll
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;; Setting deleted files to trash
(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

;; Emojify is an Emacs extension to display emojis. It can display github style emojis like :smile: or plain ascii ones like :).
(use-package emojify
  :hook (after-init . global-emojify-mode))

;; EWW is the Emacs Web Wowser, the builtin browser in Emacs.  Below I set urls to open in a specific browser (eww) with browse-url-browser-function.
(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words
      (:prefix ("e" . "evaluate/ERC/EWW")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload))

;; Emacs window manager
(autoload 'exwm-enable "exwm-config.el")

;; Some custom functions to insert the date.
(defun insert-todays-date (prefix)
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%A, %B %d, %Y")
                 ((equal prefix '(4)) "%m-%d-%Y")
                 ((equal prefix '(16)) "%Y-%m-%d"))))
    (insert (format-time-string format))))

(require 'calendar)
(defun insert-any-date (date)
  "Insert DATE using the current locale."
  (interactive (list (calendar-read-date)))
  (insert (calendar-date-string date)))

;; Emacs Dashboard is an extensible startup screen showing you recent files, bookmarks, agenda items and an Emacs banner.
(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.doom.d/doom-emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")
                                    (Agenda . "org"))))

(map! :leader
      (:prefix ("i d" . "Insert date")
        :desc "Insert any date" "a" #'insert-any-date
        :desc "Insert todays date" "t" #'insert-todays-date))

;; Ivy is a generic completion mechanism for Emacs.
;; Ivy-posframe is an ivy extension, which lets ivy use posframe to show its candidate menu.
(setq ivy-posframe-display-functions-alist
      '((swiper                     . ivy-posframe-display-at-point)
        (complete-symbol            . ivy-posframe-display-at-point)
        (counsel-M-x                . ivy-display-function-fallback)
        (counsel-esh-history        . ivy-posframe-display-at-window-center)
        (counsel-describe-function  . ivy-display-function-fallback)
        (counsel-describe-variable  . ivy-display-function-fallback)
        (counsel-find-file          . ivy-display-function-fallback)
        (counsel-recentf            . ivy-display-function-fallback)
        (counsel-register           . ivy-posframe-display-at-frame-bottom-window-center)
        (dmenu                      . ivy-posframe-display-at-frame-top-center)
        (nil                        . ivy-posframe-display))
      ivy-posframe-height-alist
      '((swiper . 20)
        (dmenu . 20)
        (t . 10)))
(ivy-posframe-mode 1) ; 1 enables posframe-mode, 0 disables it.

(map! :leader
      (:prefix ("v" . "Ivy")
       :desc "Ivy push view" "v p" #'ivy-push-view
       :desc "Ivy switch view" "v s" #'ivy-switch-view))

;; Markdown
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.2)))))

;; A minimap sidebar displaying a smaller version of the current buffer on either the left or right side.
;; It highlights the currently shown region and updates its position automatically.
;; Be aware that this minimap program does not work in Org documents.
(setq minimap-window-location 'right)
(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Toggle minimap-mode" "m" #'minimap-mode))

;; The modeline is the bottom status bar that appears in Emacs windows.
;; For more info: https://github.com/seagle0128/doom-modeline
(set-face-attribute 'mode-line nil)
(setq doom-modeline-height 30     ;; sets modeline height
      doom-modeline-bar-width 5   ;; sets right bar width
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t) ;; adds folder icon next to persp name

;; Mouse support in the Emacs terminal.
(xterm-mouse-mode 1)

;; Neotree is a file tree viewer. When you open neotree, it jumps to the current file thanks to neo-smart-open.
;; The neo-window-fixed-size setting makes the neotree width be adjustable.
(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'neotree-toggle
      :desc "Open directory in neotree" "d n" #'neotree-dir)

;; Org mode
(after! org
  (setq org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("wiki" . "https://en.wikipedia.org/wiki/")
            ("brave . https://search.brave.com/?q="))
             ))

;; Org agenda
(after! org
  (setq org-agenda-files '("~/Documentos/Org-agenda/agenda.org")))

(setq
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   ;; org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))

          (agenda "")
          (alltodo "")))))

;; Rainbox mode displays the actual color for any hex value color.  It’s such a nice feature that
;; I wanted it turned on all the time, regardless of what mode I am in.
;; The following creates a global minor mode for rainbow-mode and enables it
;; (exception: org-agenda-mode since rainbow-mode destroys all highlighting in org-agenda).
(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )

;; I set splits to default to opening on the right using ‘prefer-horizontal-split’.
;; I set a keybinding for ‘clone-indirect-buffer-other-window’ for when I want to have the same document in two splits.
;; The text of the indirect buffer is always identical to the text of its base buffer; changes made by editing either one
;; are visible immediately in the other.  But in all other respects, the indirect buffer and its base buffer are completely separate.
(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)

;;(setq initial-buffer-choice "~/.doom.d/start.org")
;;
;;(define-minor-mode start-mode
;;  "Provide functions for custom start page."
;;  :lighter " start"
;;  :keymap (let ((map (make-sparse-keymap)))
;;          ;;(define-key map (kbd "M-z") 'eshell)
;;            (evil-define-key 'normal start-mode-map
;;              (kbd "1") '(lambda () (interactive) (find-file "~/.doom.d/config.el"))
;;              (kbd "2") '(lambda () (interactive) (find-file "~/.doom.d/init.el"))
;;              (kbd "3") '(lambda () (interactive) (find-file "~/.doom.d/packages.el")))
;;          map))
;;
;;(add-hook 'start-mode-hook 'read-only-mode) ;; make start.org read-only; use 'SPC t r' to toggle off read-only.
;;(provide 'start-mode)
