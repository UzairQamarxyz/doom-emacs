;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Font
(setq doom-font (font-spec :family "IosevkaCustom Nerd Font" :size 16)
      ;; doom-symbol-font (font-spec :family "Symbola" :size 14)
      doom-variable-pitch-font (font-spec :family "Proxima Nova" :size 14)
      )

;; Theme
(setq doom-theme 'kanagawa)

;; Numberline
(setq display-line-numbers-type 'relative)

;; Org-mode
(setq org-directory "~/Documents/org")

;; Set Transparency
(set-frame-parameter (selected-frame) 'alpha '(90 90))
(add-to-list 'default-frame-alist '(alpha 90 90))
(setq org-hide-emphasis-markers t)

(after! persp-mode
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))

;; Set fringe style
;; (set-fringe-mode 0)

;; Ignore .terraform folders
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.terraform\\'"))

;; Cfn-Lint
(define-derived-mode cfn-yaml-mode yaml-mode
  "CFN-YAML"
  "Simple mode to edit CloudFormation template in YAML format.")

(add-to-list 'magic-mode-alist
             '("\\(---\n\\)?AWSTemplateFormatVersion:" . cfn-yaml-mode))

;; Set up cfn-lint integration if flycheck is installed
;; Get flycheck here https://www.flycheck.org/
(when (featurep 'flycheck)
  (flycheck-define-checker cfn-lint
    "AWS CloudFormation linter using cfn-lint.

Install cfn-lint first: pip install cfn-lint

See `https://github.com/aws-cloudformation/cfn-python-lint'."

    :command ("cfn-lint" "-f" "parseable" source)
    :error-patterns ((warning line-start (file-name) ":" line ":" column
                              ":" (one-or-more digit) ":" (one-or-more digit) ":"
                              (id "W" (one-or-more digit)) ":" (message) line-end)
                     (error line-start (file-name) ":" line ":" column
                            ":" (one-or-more digit) ":" (one-or-more digit) ":"
                            (id "E" (one-or-more digit)) ":" (message) line-end))
    :modes (cfn-json-mode cfn-yaml-mode))

  (add-to-list 'flycheck-checkers 'cfn-lint)
  (add-hook 'cfn-json-mode-hook 'flycheck-mode)
  (add-hook 'cfn-yaml-mode-hook 'flycheck-mode))

(setq fancy-splash-image "/home/uzair/Pictures/vectors/wallpaper.png")

(setq lsp-modeline-code-action-fallback-icon "")
(require 'lsp-mode)

;; Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))

  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  (add-to-list 'copilot-indentation-alist '(go-mode 2))
  (add-to-list 'copilot-indentation-alist '(terraform-mode 2)))

;; LSP-Terraform
;; (setq lsp-terraform-ls-enable-show-reference t)
(setq lsp-semantic-tokens-enable t)
(setq lsp-semantic-tokens-honor-refresh-requests t)
(setq lsp-enable-links t)
;; (setq lsp-terraform-ls-prefill-required-fields t)
