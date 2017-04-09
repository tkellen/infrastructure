;; use js2-mode instead of javascript-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; enable markdown modes
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
