(package-initialize)

;; Cask設定ファイルの読み込み
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; load-pathの追加
(add-to-list 'load-path "~/.emacs.d/github/auto-complete-acr.el")
(add-to-list 'load-path "~/.emacs.d/github/init-loader")
(add-to-list 'load-path "~/.emacs.d/github/helm-myR.el")

;; 各設定ファイルの読み込み
(require 'init-loader)
(init-loader-load "~/.emacs.d/Inits/")


