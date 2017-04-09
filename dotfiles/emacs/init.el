;; load melpa
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; assign full path to root of my emacs config
(defvar root-dir (file-name-directory load-file-name))

;; assign full path to my config folder
(defvar config-dir (expand-file-name "config" root-dir))

;; assign full path to my modules folder
(defvar config-dir (expand-file-name "modules" root-dir))

;; load my config dir in alphabetical order
(message "Loading my configuration files in %s..." config-dir)
  (mapc 'load (directory-files config-dir 't "^[^#].*el$"))

;; add modules to load path so they can be required directly
;;(add-to-list 'load-path "modules" root-dir)

;; start the daemon
(server-start)
