;; 日本語化
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(prefer-coding-system 'utf-8)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; ウィンドウを透明にする
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.95 0.85)))

;; メニューバーを消す
(menu-bar-mode -1)

;; ツールバーを消す
(tool-bar-mode -1)

;;F7キーでファイルをロード
(defun my-load-current-buffer-file ()
  "Load current buffer file"
  (interactive)
  (basic-save-buffer)
  (load (buffer-file-name)))

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key [f7] 'my-load-current-buffer-file)))

;; 行番号の表示
(global-linum-mode t)
(setq linum-format "%4d|")
;; 列数を表示する
(column-number-mode t)


;; モードラインに時刻を表示する
(display-time)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (misterioso)))
 '(package-selected-packages
   (quote
    (ess-R-object-popup yasnippet web-mode use-package smex smartparens projectile prodigy popwin pallet nyan-mode multiple-cursors magit idle-highlight-mode htmlize flycheck-cask expand-region exec-path-from-shell drag-stuff))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; find-fileのデフォルトディレクトリ設定
(setq default-directory "~/") 
(setq command-line-default-directory "~/")

;; 起動時のウィンドウサイズ、色などを設定
(if (boundp 'window-system)
    (setq default-frame-alist
          (append (list
                   ;;'(foreground-color . "black")  ; 文字色
                   ;;'(background-color . "white")  ; 背景色
                   ;;'(border-color     . "white")  ; ボーダー色
                   ;;'(mouse-color      . "black")  ; マウスカーソルの色
                   ;;'(cursor-color     . "black")  ; カーソルの色
                   ;;'(cursor-type      . box)      ; カーソルの形状
                   '(top . 60) ; ウィンドウの表示位置（Y座標）
                   '(left . 45) ; ウィンドウの表示位置（X座標）
                   '(width . 190) ; ウィンドウの幅（文字数）
                   '(height . 90) ; ウィンドウの高さ（文字数）
                   )
                  default-frame-alist)))
(setq initial-frame-alist default-frame-alist )
(split-window-horizontally)		;左右に2分割
(other-window 1)
(split-window-vertically)		;上下に2分割

;; フレーム移動のキー設定
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(global-set-key (kbd "C-t") 'other-window-or-split)

;;自動で色を付ける設定
(global-font-lock-mode t)

;; 括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed) 

;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#FF6666")

;; 対応する括弧を光らせる。
(show-paren-mode 1)

;; 閉じカッコ補完
(electric-pair-mode 1)

;; anything.elの設定
(require 'anything-config)
(define-key global-map (kbd "C-x b") 'anything)

(setq anything-sources
'(anything-c-source-buffers
anything-c-source-emacs-commands
anything-c-source-file-name-history
anything-c-source-locate
anything-c-source-man-pages
anything-c-source-occur
anything-c-source-recentf
anything-c-source-R-local
anything-c-source-R-help
))

(setq recentf-auto-cleanup 'never)	;フリーズ対策

;; ---------------------------------------------------------
;; auto-complete の設定
;; ---------------------------------------------------------
(require 'auto-complete)
(require 'auto-complete-config)
(require 'auto-complete-yasnippet)
(require 'auto-complete-acr)
(global-auto-complete-mode t)
(setq ac-auto-show-menu 0.2) ; 補完リストが表示されるまでの時間
(define-key ac-completing-map (kbd "C-n") 'ac-next)      ; C-n で次候補選択
(define-key ac-completing-map (kbd "C-p") 'ac-previous)  ; C-p で前候補選択
;; ファイルパスの補完
(global-set-key [(alt tab)] 'ac-complete-filename)
(setq ac-dwim t)  ; 空気読んでほしい
;; 情報源として
;; * ac-source-filename
;; * ac-source-words-in-same-mode-buffers
;; を利用
(setq-default ac-sources '(ac-source-filename
                           ac-source-words-in-same-mode-buffers
                           ac-source-yasnippet))

(setq ac-auto-start 3);; 補完を開始する文字数

;; 色
(set-face-background 'ac-completion-face "#333333")
(set-face-foreground 'ac-candidate-face "black")
(set-face-background 'ac-selection-face "#666666")
(set-face-foreground 'popup-summary-face "black")  ;; 候補のサマリー部分
(set-face-background 'popup-tip-face "#ffffd8")  ;; ドキュメント部分
(set-face-foreground 'popup-tip-face "black")

