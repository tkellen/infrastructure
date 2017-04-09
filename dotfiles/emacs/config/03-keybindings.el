;; make fn key act as hyper
(setq ns-function-modifier 'hyper)

;; across all of emacs, bind meta x to use helm
(global-set-key (kbd "M-x") 'helm-M-x)

;; switch windows a little faster
(global-set-key (kbd "M-o") 'other-window)

(require 'helm)

;; in helm, use tab for completion rather than select-action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)

;; in helm, show which actions are available for the current selection
(define-key helm-map (kbd "C-z") 'helm-select-action)

;; use isearch
(global-set-key (kbd "M-i") 'imenu)

;; use hyper-space to turn on multi column selection
(global-set-key (kbd "H-SPC") `set-rectangular-region-anchor)

(global-set-key (kbd "H-d") `mc/mark-next-like-this)

(global-set-key (kbd "H-a") `mc/mark-all-like-this)
