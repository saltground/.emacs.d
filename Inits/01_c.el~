;;---------------------------------------------------------------------------
;;C言語用カスタム
;;---------------------------------------------------------------------------

(require 'cc-mode)

;;自動インデント
(add-hook 'c-mode-common-hook
        '(lambda()
;;センテンスの終了である';'を入力したら、自動改行+インデント
        (c-toggle-auto-hungry-state 1)
;;RETキーで自動改行+インデント
        (define-key c-mode-base-map"\C-m"newline-and-indent)
;; タブは利用しない
	(setq indent-tabs-mode nil)
	))

;; C-c c で compile コマンドを呼び出す
(define-key mode-specific-map "c" 'compile)


;;C-c C-z で shell コマンドを呼び出す
(define-key mode-specific-map "z" 'shell-command)

;; completion
(require 'auto-complete-c-headers)
(add-hook 'c++-mode-hook '(setq ac-sources (append ac-sources '(ac-source-c-headers))))
(add-hook 'c-mode-hook '(setq ac-sources (append ac-sources '(ac-source-c-headers))))

(require 'c-eldoc)
(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)
(add-hook 'c++-mode-hook 'c-turn-on-eldoc-mode)
(setq c-eldoc-buffer-regenerate-time 60)
