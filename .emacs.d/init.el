(add-to-list 'load-path "~/.emacs.d/lisp/")

(load "~/.emacs.d/rc.el" :nomessage t)

(setq-default truncate-lines t
              inhibit-startup-screen t
              indent-tabs-mode nil
              tab-width 3)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5
      display-line-numbers-type 'relative
      warning-minimum-level :error)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)
(global-display-line-numbers-mode 1)

(rc/require-theme 'catppuccin)

(defun rc/duplicate-line ()
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

;;; ido
(rc/require 'smex 'ido-completing-read+)

(require 'ido-completing-read+)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)

;;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))

(require 'fasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(require 'oak-mode)
(add-to-list 'auto-mode-alist '("\\.oak\\'" . oak-mode))

(require 'hare-mode)
(add-to-list 'auto-mode-alist '("\\.ha\\'" . hare-mode))

;;; whitespace-mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(setq whitespace-style '(face tabs trailing space-before-tab newline indentation space-after-tab tab-mark))
(add-hook 'prog-mode-hook 'rc/set-up-whitespace-handling)

;;; magit
(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;;; multiple-cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;;; dired
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)
(add-hook 'dired-mode-hook (lambda () (display-line-numbers-mode 0)))

;;; yasnippet
(rc/require 'yasnippet)

(require 'yasnippet)

(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.d/snippets/"))

(yas-global-mode 1)

;;; word-wrap
(defun rc/enable-word-wrap ()
  (interactive)
  (toggle-word-wrap 1))

(add-hook 'markdown-mode-hook 'rc/enable-word-wrap)

;;; corfu
(rc/require 'corfu)
(setq corfu-cycle t)

(global-corfu-mode 1)

;;; typescript-mode
(rc/require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.mts\\'" . typescript-mode))

;;; tide
(rc/require 'tide)

(defun rc/turn-on-tide-and-flycheck ()
  (interactive)
  (tide-setup)
  (flycheck-mode 1))

(add-hook 'typescript-mode-hook 'rc/turn-on-tide-and-flycheck)

;;; tex-mode
(add-hook 'tex-mode-hook
          (lambda ()
            (interactive)
            (add-to-list 'tex-verbatim-environments "code")))

(setq font-latex-fontify-sectioning 'color)

;;; move-text
(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;;; no-config packages
(rc/require
 'yaml-mode
 'glsl-mode
 'lua-mode
 'less-css-mode
 'graphviz-dot-mode
 'cmake-mode
 'rust-mode
 'jinja2-mode
 'markdown-mode
 'dockerfile-mode
 'toml-mode
 'go-mode
 'php-mode
 'typescript-mode
 )

;;; compile
(require 'compile)

(setq-default compilation-scroll-output t)
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(defun rc/colorize-compilation-buffer ()
  (read-only-mode 'toggle)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 'toggle))
(add-hook 'compilation-filter-hook 'rc/colorize-compilation-buffer)

;; scrolling
(rc/require 'smooth-scrolling)
(smooth-scrolling-mode 1)
(rc/require 'good-scroll)
(good-scroll-mode 1)

(setq hscroll-margin 5
      hscroll-step 1)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;; eshell
(add-hook 'eshell-mode-hook (lambda () (display-line-numbers-mode 0)))

(advice-add 'split-window-right :after #'tear-off-window)
(advice-add 'split-window-below :after #'tear-off-window)
