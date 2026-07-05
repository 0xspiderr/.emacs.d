;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; splash screen config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; package manager config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
						 ("org" . "https://orgmode.org/elpa/")
						 ("elpa" . "https://elpa.gnu.org/packages/"))
)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; theme config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-theme 'modus-vivendi t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ui elements config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (set-fringe-mode 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dashboard(custom splashscreen)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dashboard
  :ensure t
  :custom
  (dashboard-banner-logo-title nil)
  (dashboard-startup-banner "~/.emacs.d/img/images.jpeg")
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-items '((recents . 5)))
  (dashboard-navigation-cycle t)
  (dasboard-jump-to-recents)
  :config
  (dashboard-setup-startup-hook)
  ;; for putting the cursor at the start of the first recent file
 (add-hook 'dashboard-after-initialize-hook
			(lambda()
			(dashboard-jump-to-recents)))
)
(require 'dashboard-widgets)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; line and columns config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(column-number-mode)
(hl-line-mode)
(setq-default tab-width 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fonts config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-face-attribute 'default nil :family "PxPlus IBM VGA 8x16" :height 140)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vertico config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t) ;; cycle when reaching the end of the list
  :init
  (vertico-mode))

;; persit history over emacs restarts
(use-package savehist
  :ensure t
  :init
  (savehist-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  ;; set relative line numbers
  (evil-mode 1)
)
(require 'evil-vars)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general and which-key config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package general
  :ensure t
  :init
  (general-evil-setup t))

(use-package which-key
  :ensure t
  :init (which-key-mode))
(setq which-key-idle-delay 1.0)

(use-package recentf
  :ensure nil ;; built in emacs
  :init
  (recentf-mode 1)
  :custom
  (recentf-max-saved-items 20))

(defun fn/find-recent-file()
  "find recently opened files using vertico"
  (interactive)
  (find-file (completing-read "recent files:" recentf-list)))

;; keybind custom methods
(setq init-file "~/.emacs.d/init.el") ;; for finding it
(defun fn/edit-config-file()
  "opens the init file"
  (interactive)
  (find-file init-file)
  )

(setq org-dir "~/org") ;; for finding org dir
(defun fn/open-org-dir()
  "opens the org directory"
  (interactive)
  (find-file org-dir)
  )

(defun fn/latex-toggle-pdf()
  "toggle the side by side pdf preview window"
  (interactive)
  (let ((pdf-buffer (get-buffer (concat (file-name-base (buffer-file-name)) ".pdf"))))
	(if (and pdf-buffer (get-buffer-window pdf-buffer))
		;; if pdf open, close it
		(delete-window (get-buffer-window pdf-buffer))
	  ;; else open it
	  (TeX-view))))

;; doom emacs-like keybindings
(general-define-key
 :states '(normal visual insert emacs)
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "C-SPC"
 ""    '(:ignore t :which-key "leader key")
 "."   '(find-file :which-key "find file")
 
 "f"   '(:ignore t :which-key "files")
 "f c" '(fn/edit-config-file :which-key "edit emacs config file")
 "f f" '(find-file :which-key "find file")
 "f s" '(save-buffer :which-key "save file")
 "f r" '(fn/find-recent-file :which-key "recent files")
 
 "b"   '(:ignore t :which-key "buffers")
 "b ," '(previous-buffer :which-key "previous buffer")
 "b ." '(next-buffer :which-key "next buffer")
 "b k" '(kill-current-buffer :which-key "kill current buffer")

 "o"   '(:ignore t :which-key "open")
 "o s" '(eshell :which-key "eshell") ;; might change from eshell
 "o o" '(fn/open-org-dir :which-key "org")

 "w"   '(:ignore t :which-key "windows")
 "w k" '(delete-window :which-key "delete window") ;; duplicate, dependes on how i have my hands on my keyboard :^)
 "w c" '(delete-window :which-key "delete window")
 "w h" '(dashboard-open :which-key "go to dashboard")

 "c"   '(:ignore t :which-key "code")
 "c e" '(quickrun :which-key "execute code in current buffer")
 "c a" '(quickrun-with-arg :which-key "execute code with args")
 "c s" '(quickrun-shell :which-key "execute code in shell")
 "c f" '(eglot-format :which-key "format code")
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org mode config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fn/org-mode-setup()
  (org-indent-mode)
  (variable-pitch-mode 0)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :ensure t
  :hook (org-mode . fn/org-mode-setup)
  :config
  (setq org-ellipsis " V"
		org-hide-emphasis-markers t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; latex config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(with-eval-after-load 'latex
  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps 'LaTeX-mode-map
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "l"   '(:ignore t :which-key "latex")
   "l v" '(fn/latex-toggle-pdf :which-key "view LaTeX pdf")))

(use-package auctex
  :ensure t
  :config
  (setq TeX-PDF-mode t) ;; default to export pdfs
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master t))

(defun fn/latex-compile()
  "compile the latex doc in the background"
  (when (eq major-mode 'LaTeX-mode)
	(let ((TeX-process-asynchronous t)
		  (TeX-save-query nil))
	  (TeX-command-sequence t t))))

(add-hook 'after-save-hook #'fn/latex-compile)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pdf-tools config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package pdf-tools
  :ensure t
  :init
  (pdf-loader-install)
  :config
  ;; disable global line numbers on pdf window
  (add-hook 'pdf-view-mode-hook (lambda() (display-line-numbers-mode -1)))
  ;; auctex opens pdf with pdf-tools instead of system pdf reader
  (with-eval-after-load 'tex
	(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
		  TeX-view-program-list '(("PDF Tools" "TeX-pdf-tools-sync-view")))
	)

  ;; auto-refresh pdf after compile
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dired config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(with-eval-after-load 'dired
  ;; open file with RET key
  (evil-define-key 'normal dired-mode-map (kbd "RET") 'dired-find-file)
  (evil-define-key 'normal dired-mode-map (kbd "<return>") 'dired-find-file)

  ;; navigate with left and right arrow keys through dirs
  (evil-define-key 'normal dired-mode-map (kbd "<right>") 'dired-find-file)
  (evil-define-key 'normal dired-mode-map (kbd "l")       'dired-find-file)
  (evil-define-key 'normal dired-mode-map (kbd "<left>")  'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "h")       'dired-up-directory)) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lsp config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gdscript
(use-package gdscript-mode)

(use-package eglot
  :ensure nil ;; built in
  :hook ((python-mode . eglot-ensure)
		 (c-mode . eglot-ensure)
		 (c++-mode . eglot-ensure)
		 (emacs-lisp-mode . eglot-ensure)
		 (LaTeX-mode . eglot-ensure)
		 (gdscript-mode . eglot-ensure)))

;; for auto completion
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2) ;; trigger after 2 chars typed
  (corfu-auto-delay 0.1)
  (corfu-quit-no-match 'separator)
  (corfu-popupinfo-delay 0)
  :init
  (global-corfu-mode) ;; turn on for every file
  (corfu-popupinfo-mode) ;; show docs alongside the completion
)

;; parenthesis config
(show-paren-mode 1)
(electric-pair-mode 1) ;; auto close parenthesis
(setq show-paren-delay 0.0)
(setq electric-pair-pairs
	  '((?\( . ?\))
		(?\[ . ?\])
		(?\{ . ?\})))

;; quickrun
(use-package quickrun
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom set variables config(auto generated)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(quickrun gdscript-mode corfu eglot company-box company lsp-mode flycheck vertico which-key general evil ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
