(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(use-package emacs
  :ensure nil
  :custom
  (inhibit-startup-screen t)
  (ring-bell-function #'ignore)
  (redisplay-dont-pause t)
  (scroll-margin 3)
  (scroll-conservatively 10000)
  (scroll-preserve-screen-position t)
  (make-backup-files nil)
  (display-line-numbers 'relative)
  (truncate-lines t)
  (make-pointer-invisible t)
  (indent-tabs-mode nil)
  (whitespace-style '(face spaces empty tabs newline trailing))
  :init
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (electric-pair-mode)
  (delete-selection-mode)
  (column-number-mode)
  (line-number-mode)
  (global-hl-line-mode)
  (blink-cursor-mode -1)
  (global-whitespace-mode))

(use-package catppuccin-theme
  :ensure t
  :init
  (load-theme 'catppuccin :no-confirm))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package consult
  :ensure t
  :bind (("C-c m" . consult-man)
	 ("C-x b" . consult-buffer)
	 ("M-g e" . consult-compile-error)
	 ("M-g g" . consult-goto-line)
	 ("M-s d" . consult-fd)
	 ("M-s r" . consult-ripgrep)))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package cape
  :ensure t
  :bind (("C-n" . completion-at-point)))

(use-package magit
  :ensure t)

(use-package odin-mode :ensure (:host github :repo "mattt-b/odin-mode"))
(use-package nim-mode :ensure t)
(use-package haskell-mode :ensure t)
(use-package markdown-mode :ensure t)
(use-package nasm-mode :ensure t)
(use-package fasm-mode :ensure (:host github :repo "emacsattic/fasm-mode"))
(use-package esol-mode :load-path "~/projects/esol/editors")
