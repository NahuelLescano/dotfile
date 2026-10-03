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
;; Fix compatibilidad Emacs 31 + doom-themes (rompe ciclo de herencia en Gnus)

(require 'gnus-group nil t)
(defface gnus-group-news-low-empty '((t :inherit default)) "Emacs 31 fix" :group 'gnus-group)
(defface gnus-group-news-low '((t :inherit default)) "Emacs 31 fix" :group 'gnus-group)
(set-face-attribute 'gnus-group-news-low nil :inherit 'default)
(set-face-attribute 'gnus-group-news-low-empty nil :inherit 'default)

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
;; Carga diferida de Copilot sin bloquear el inicio ni la apertura de buffers
(use-package! copilot
  :defer t
  :commands (copilot-mode copilot-complete)
  ;; Se activa sólo tras 1.5 segundos de inactividad al editar código
  :hook (prog-mode . (lambda ()
                       (run-with-idle-timer 1.5 nil
                                            (lambda (buf)
                                              (when (buffer-live-p buf)
                                                (with-current-buffer buf
                                                  (copilot-mode 1))))
                                            (current-buffer))))
  :bind (:map copilot-completion-map
              ("<C-j>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ("C-TAB" . copilot-accept-completion-by-word)
              ("C-<tab>" . copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t
        ;; Aumenta el tiempo de espera antes de pedir sugerencias (reduce llamadas continuas)
        copilot-idle-delay 0.3))

;; Minimap configuration
(after! minimap
  (setq minimap-width 20)
  (setq minimap-update-delay 0.2)
  (setq minimap-hide-cursor t)
  (setq minimap-hide-scroll-bar t)
  (setq minimap-hide-fringes t)
  (setq minimap-highlight-line t))

; Beacon activation
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


;; Org-mode configuration
(after! org
  (setq org-ellipsis " ▼ "
        org-log-done 'time
        org-hide-emphasis-markers t))

(after! org-superstar
  (setq org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)))
  (add-hook 'org-mode-hook #'org-superstar-mode))

;; Tree-sitter configuration for TypeScript and TSX
(after! treesit
  (setq treesit-language-source-alist
        '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src" nil nil)
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src" nil nil)
          (css "https://github.com/tree-sitter/tree-sitter-css" nil nil nil nil))))

;; Global indentation settings
(setq-default indent-tabs-mode nil
              tab-width 2)
(setq evil-shift-width 2)

(add-hook! 'prog-mode-hook
  (setq-local tab-width 2
              evil-shift-width 2))

;; C/C++ indentation settings
(after! cc-vars
  (setq-default c-basic-offset 2)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'inline-open 0))

(add-hook! '(java-mode-hook java-ts-mode-hook)
  (setq-local c-basic-offset 2))

;; JavaScript and TypeScript indentation settings
(setq-default tab-width 2)
(setq evil-shift-width 2)
(setq-default indent-tabs-mode nil)

(setq-default tab-width 2)
(setq evil-shift-width 2)
(setq-default indent-tabs-mode nil)

(setq js-indent-level 2
      typescript-indent-level 2)

(add-hook! '(js-mode-hook js-ts-mode-hook rjsx-mode-hook typescript-ts-mode-hook)
  (setq-local js-indent-level 2
              typescript-indent-level 2))


;; lsp mode and java configuration
(setq gc-cons-threshold 100000000)              ; 100 MB para evitar pauses constantes de GC
(setq read-process-output-max (* 3 1024 1024))  ; 3 MB (mejora la lectura de pipes de JDTLS)

(after! lsp-mode
  (setq lsp-idle-delay 0.500
        lsp-log-io nil                          ; Desactivar el logging masivo en disco/buffer
        lsp-enable-file-watchers nil            ; NO escanear recursivamente carpetas (evita freezes gigantes)
        lsp-enable-folding nil                  ; Desactiva folding por LSP (Tree-sitter/Doom ya lo hacen)
        lsp-enable-symbol-highlighting nil      ; Evita recalcular referencias cada vez que mueves el cursor
        lsp-lens-enable nil                     ; CRUCIAL: lenses hace llamadas pesadas de conteo de referencias
        lsp-headerline-breadcrumb-enable nil)   ; Desactiva la barra superior si notas lag de renderizado

  ;; Evitar que el autocompletado bloquee la UI
  (setq lsp-completion-provider :capf))

(after! lsp-ui
  ;; lsp-ui-doc y sideline son los mayores culpables de stuttering visual
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-delay 1.5               ; Aumentar el delay para que no intente renderizar en cada movimiento
        lsp-ui-sideline-enable nil))       ; Desactivar el sideline (lo que se dibuja al margen derecho)

(after! lsp-java
  ;; Darle suficiente memoria heap a JDTLS para que no haga thrashing de GC
  (setq lsp-java-vmargs
        '("-XX:+UseParallelGC"
          "-XX:GCTimeRatio=4"
          "-XX:AdaptiveSizePolicyWeight=90"
          "-Dsun.zip.disableMemoryMapping=true"
          "-Xmx2G"                         ; Asigna hasta 2GB de RAM a la JVM del LSP
          "-Xms512m"))                     ; Arranca con 512MB de base

  ;; Desactivar descargas o indexaciones automáticas secundarias
  (setq lsp-java-sources-organize-imports-on-format nil
        lsp-java-autobuild-subprojects nil))

;; Configuración específica para Java (lsp-java + Eclipse JDTLS)
(after! lsp-java
  (setq lsp-java-format-enabled t
        lsp-java-save-actions-organize-imports t))

;; Set a custom splash image for Doom Emacs
(setq fancy-splash-image "~/.doom.d/doom-emacs-dash.png")

;; plantuml-mode configuration
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

;; eww weird background and foreground colors.
(after! eww
  (setq shr-use-colors nil
        shr-use-fonts nil)

  (custom-set-faces!
    '(shr-text
      :inherit default
      :background unspecified
      :foreground unspecified)

    '(shr-h1
      :inherit (default bold)
      :background unspecified)

    '(shr-h2
      :inherit (default bold)
      :background unspecified)

    '(shr-h3
      :inherit (default bold)
      :background unspecified)

    '(shr-link
      :inherit link
      :background unspecified)

    '(shr-code
      :inherit fixed-pitch
      :background unspecified)

    '(shr-pre
      :inherit fixed-pitch
      :background unspecified)))
