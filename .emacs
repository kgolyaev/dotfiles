(setq user-full-name "Konstantin Golyaev")
(setq user-mail-address "kgolyaev@amazon.com")

;; mac - make sure command line is meta
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; Setting up MELPA
(require 'package)
(load "package")
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
;; so was this
(setq package-archive-enable-alist '(("melpa" deft magit)))

;; packages - this piece does not seem to work

;; startup options
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;; clipboard and such
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; disable tabs
(setq tab-width 2
      indent-tabs-mode nil)

;; abbreviate yes or no
(defalias 'yes-or-no-p 'y-or-n-p)


;; some key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

;; some more fun stuff
(setq echo-keystrokes 0.1
      visible-bell t)
(show-paren-mode t)

;; bindings for smex
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; column number mode and line number
(setq column-number-mode t)
(setq global-linum-mode t)

;; auto-insert brace pair
(require 'autopair)

;; auto-complete
(require 'auto-complete-config)
(ac-config-default)

;; untabify and cleanup code
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)

;; added from prior configs
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; remap HOME and END keys to work as I expect them to
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [end] 'end-of-line)

;; remap command and control functions in emacs
;;(setq mac-command-modifier 'control)
;;(setq mac-control-modifier 'meta)

;; tramp
(custom-set-variables
  '(tramp-default-method "ssh")
  '(tramp-password-prompt-regexp "^.*\\([pP]assword\\|passphrase\\|Response\\).*:\^@? *"))
 (custom-set-faces)


