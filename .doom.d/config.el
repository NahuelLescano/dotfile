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
;; - `doom-symbol-font' -- for symbols
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
(setq doom-theme 'doom-tokyo-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

(setq doom-font (font-spec :family "IosevkaTerm Nerd Font" :size 18 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "IosevkaTerm Nerd Font" :size 18))

;; Set transparency for the Emacs frame
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Non-POSIX compliant shells (particularly Fish and Nushell) can cause
;; unpredictable issues with any Emacs utilities that spawn child processes from
;; shell commands (like diff-hl TRAMP, and terminal emulators). To get around this,
;; configure Emacs to use a POSIX shell internally, e.g.
(setq shell-file-name (executable-find "bash"))

;; Emacs' terminal emulators can be safely configured to use your original $SHELL:

(setq-default vterm-shell "/usr/bin/fish"
              explicit-shell-file-name "/usr/bin/fish")

;; accept completion from copilot and fallback to company
(use-package! copilot
  :defer t
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<C-j>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; Minimap configuration
(after! minimap
  (setq minimap-width 20)
  (setq minimap-update-delay 0.2)
  (setq minimap-hide-cursor t)
  (setq minimap-hide-scroll-bar t)
  (setq minimap-hide-fringes t)
  (setq minimap-highlight-line t))

;; Configuración de indentación para JavaScript y TypeScript
(setq-default tab-width 2)
(setq evil-shift-width 2)
(setq-default indent-tabs-mode nil)

(add-hook 'js-mode-hook (lambda () (setq-local js-indent-level 2)))
(add-hook 'js-ts-mode-hook (lambda () (setq-local js-indent-level 2)))

(after! lsp-mode
  (setq lsp-deno-active nil)
  
  ;; Desactivar deno para JS/TS y usar typescript-language-server
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "typescript-language-server" "--stdio")
                    :major-modes '(js-mode js-ts-mode typescript-mode typescript-ts-mode)
                    :server-id 'ts-ls)))

;; Beacon activation
(beacon-mode t)


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


;; Org mode
(after! org
  (setq org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t))

;; Tree-sitter configuration for TypeScript and TSX
(after! treesit
  (setq treesit-language-source-alist
        '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src" nil nil)
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src" nil nil)
          (css "https://github.com/tree-sitter/tree-sitter-css" nil nil nil nil))))

;; Keybinding for LSP format buffer
(map! :after lsp-mode
      :map lsp-mode-map
      :leader
      (:prefix ("l", "lsp")
        :desc "LSP format buffer" "f" #'lsp-format-buffer))

;; Magit configuration to remove certain sections from the status buffer
(after! magit
  (setq magit-status-sections-hook
        (remove 'magit-insert-rebase-sequence magit-status-sections-hook))
  (setq magit-status-sections-hook
        (remove 'magit-insert-am-sequence magit-status-sections-hook))
  (setq magit-status-sections-hook
        (remove 'magit-insert-sequencer-sequence magit-status-sections-hook))
  (setq magit-status-sections-hook
        (remove 'magit-insert-bisect-output magit-status-sections-hook))
  (setq magit-status-sections-hook
        (remove 'magit-insert-bisect-rest magit-status-sections-hook))
  (setq magit-status-sections-hook
        (remove 'magit-insert-bisect-log magit-status-sections-hook))
  (setq magit-status-sections-hook
        (remove 'magit-insert-stashes magit-status-sections-hook)))

;; Set a custom splash image for Doom Emacs
(setq fancy-splash-image "~/.doom.d/doom-emacs-dash.png")
