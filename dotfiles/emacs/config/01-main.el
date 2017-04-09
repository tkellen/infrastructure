;; don't show splash screen
(setq inhibit-startup-message t)

;; always load the newest byte code for packages
(setq load-prefer-newer t)

;; show line numbers
(line-number-mode t)

;; show column numbers
(column-number-mode t)

;; enable theme
(load-theme 'monokai t)

;; highlight the current line
(global-hl-line-mode)
(set-face-background 'hl-line "#22231e")
(set-face-foreground 'highlight nil)

;; make region highlight color leave syntax highlighting alone
(set-face-attribute 'region nil :background "#141513" :foreground nil)

;; use bar for cursor
(setq-default cursor-type 'bar)

;; use command key as Meta
(setq mac-command-modifier 'meta)

;; disable menu bar if available to be disabled
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; disable tool bar if available to be disabled
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; disable scroll bar if available to be disabled
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; enable helm
(require 'helm-config)

;; don't create lock files
(setq create-lockfiles nil)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; erase selections by typing
(delete-selection-mode 1)

;; maximize window on startup
(let ((px (display-pixel-width))
  (py (display-pixel-height))
  (fx (frame-char-width))
  (fy (frame-char-height))
  tx ty)
(setq tx (- (/ px fx) 7))
(setq ty (- (/ py fy) 4))
(setq initial-frame-alist '((top . 2) (left . 2)))
(add-to-list 'default-frame-alist (cons 'width tx))
(add-to-list 'default-frame-alist (cons 'height ty)))

;; save position in files when exiting
(require 'saveplace)
(setq-default save-place t)

;; provide visual feedback for undo/kill/yank/etc
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; configure how whitespace appears
(require 'whitespace)
(global-whitespace-mode 1)
(setq whitespace-style '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark newline-mark))
;; define how non-printable characters are displayed
;; e.g. (type mark-to-replace [char-to-show char-to-show])
(setq whitespace-display-mappings '(
  (space-mark ?\ [?·])
  (newline-mark ?\n [172 ?\n])
  (tab-mark ?\t [187 ?\t])
))

(defvar background-color 'unspecified)
(defvar foreground-color "gray20")
(defvar violation-foreground-color "chartreuse1")

(set-face-attribute 'whitespace-space nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-hspace nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-tab nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-newline nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-trailing nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-line nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-space-before-tab nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-indentation nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-empty nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-space-after-tab nil
                    :background background-color
                    :foreground violation-foreground-color)

;; highlight opening and closing parens
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)
(setq show-paren-delay 0)
(setq blink-matching-paren nil)

;; show ruler at 80 columns
(require 'fill-column-indicator)
(define-globalized-minor-mode my-global-fci-mode fci-mode turn-on-fci-mode)
(setq fci-rule-width 1)
(setq fci-rule-color "#22231e")
(my-global-fci-mode 1)

;; automatically insert matching pairs
(require 'smartparens-config)
(smartparens-global-mode 1)

;; enable beacon all the time
(beacon-mode 1)

;; the end of a sentence should be a single space after a period
(setq sentence-end-double-space nil)

;; enable projectile
(projectile-global-mode)
;; configure projectile to use helm
(setq projectile-completion-system 'helm)
;; turn on projectile-helm integration
(helm-projectile-on)
;; when switching projects, immediately go to helm-projectiles
(setq projectile-switch-project-action 'helm-projectile)
