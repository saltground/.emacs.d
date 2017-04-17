
;; ---------------------------------------------------------
;; ESS の設定
;; ---------------------------------------------------------
(require 'ess-site)

;R 関連--------------------------------------------
;; パスの追加
(add-to-list 'load-path "~/.emacs.d/elpa")

;; 拡張子が r, R の場合に R-mode を起動
(add-to-list 'auto-mode-alist '("\\.[rR]$" . R-mode))

;; R-mode を起動する時に ess-site をロード
(autoload 'R-mode "ess-site" "Emacs Speaks Statistics mode" t)

;; R を起動する時に ess-site をロード
(autoload 'R "ess-site" "start R" t)


;; R-mode, iESS を起動する際に呼び出す初期化関数
(setq ess-loaded-p nil)
(defun ess-load-hook (&optional from-iess-p)
  ;; インデントの幅を 2 にする（デフォルト 2）
  (setq ess-indent-level 2)
  ;; インデントを調整
  (setq ess-arg-function-offset-new-line (list ess-indent-level))
  ;; comment-region のコメントアウトに # を使う（デフォルト##）
  (make-variable-buffer-local 'comment-add)
  (setq comment-add 0)

  ;; 最初に ESS を呼び出した時の処理
  (when (not ess-loaded-p)
    ;; 補完機能を有効にする
    (setq ess-use-auto-complete t)
    ;; helm を使いたいので IDO は邪魔
    (setq ess-use-ido nil)
    ;; キャレットがシンボル上にある場合にもエコーエリアにヘルプを表示する
    (setq ess-eldoc-show-on-symbol t)
    ;; 起動時にワーキングディレクトリを尋ねられないようにする
    (setq ess-ask-for-ess-directory nil)
    ;; # の数によってコメントのインデントの挙動が変わるのを無効にする
    (setq ess-fancy-comments nil)
    (setq ess-loaded-p t)
    (unless from-iess-p
      ;; ウィンドウが 1 つの状態で *.R を開いた場合はウィンドウを横に分割して R を表示する
      (when (one-window-p)
        (split-window-below)
        (let ((buf (current-buffer)))
          (ess-switch-to-ESS nil)
          (switch-to-buffer-other-window buf)))
      ;; R を起動する前だと auto-complete-mode が off になるので自前で on にする
      ;; cf. ess.el の ess-load-extras
      (when (and ess-use-auto-complete (require 'auto-complete nil t))
        (add-to-list 'ac-modes 'ess-mode)
        (mapcar (lambda (el) (add-to-list 'ac-trigger-commands el))
                '(ess-smart-comma smart-operator-comma skeleton-pair-insert-maybe))
        ;; auto-complete のソースを追加
        (setq ac-sources '(ac-source-acr
                           ac-source-R
                           ac-source-filename
                           ac-source-yasnippet)))))

  (if from-iess-p
      ;; R のプロセスが他になければウィンドウを分割する
      (if (> (length ess-process-name-list) 0)
          (when (one-window-p)
            (split-window-horizontally)
            (other-window 1)))
    ;; *.R と R のプロセスを結びつける
    ;; これをしておかないと補完などの便利な機能が使えない
    (ess-force-buffer-current "Process to load into: ")))

;; R-mode 起動直後の処理
(add-hook 'R-mode-hook 'ess-load-hook)

;; R 起動直前の処理
(defun ess-pre-run-hooks ()
  (ess-load-hook t))
(add-hook 'ess-pre-run-hook 'ess-pre-run-hooks)

;; auto-complete-acr
(require 'auto-complete-acr)


;; ESS Auto-complete
(when (locate-library "ess-site")
(setq ess-use-auto-complete t)
;; (setq ess-use-auto-complete 'script-only)
)

;; ESS R Data View
(define-key ess-mode-map (kbd "C-c v") 'ess-R-dv-pprint)

;; ess-R-object-popup
(require 'ess-R-object-popup)
(define-key ess-mode-map "\C-c\C-g" 'ess-R-object-popup)

;; helm インタフェースで 関数のヘルプをひく
(require 'helm-myR)
(define-key ess-mode-map (kbd "C-c h") 'helm-for-R)
(define-key inferior-ess-mode-map (kbd "C-c h") 'helm-for-R)

(define-key ess-mode-map (kbd "A-h") 'helm-R-install-packages)
(define-key inferior-ess-mode-map (kbd "A-h") 'helm-R-install-packages)


;; R 起動時にワーキングディレクトリを訊ねない
(setq ess-ask-for-ess-directory nil)

;;yasnippetの設定
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)


;; e2wm-R
(require 'e2wm-R)
(global-set-key (kbd "M-+") 'e2wm:start-management)

;; e2wm:dp-R-view, e2wm:stop-management を toggleis する
(defun e2wm:toggle-management ()
  (interactive)
  (if (e2wm:pst-get-instance)
      (e2wm:stop-management) (e2wm:dp-R-view)))
(define-key ess-mode-map (kbd "C-,") 'e2wm:toggle-management)

;;anything-c-source-R-helpの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq anything-c-source-R-help
'((name . "R objects / help")
(init . (lambda ()
;; this grabs the process name associated with the buffer
(setq anything-c-ess-local-process-name ess-local-process-name)))
(candidates . (lambda ()
(condition-case nil
(ess-get-object-list anything-c-ess-local-process-name)
(error nil))))
(action
("help" . ess-display-help-on-object)
("head (10)" . (lambda(obj-name)
(ess-execute (concat "head(" obj-name ", n = 10)n") nil (concat "R head: " obj-name))))
("head (100)" . (lambda(obj-name)
(ess-execute (concat "head(" obj-name ", n = 100)n") nil (concat "R head: " obj-name))))
("tail" . (lambda(obj-name)
(ess-execute (concat "tail(" obj-name ", n = 10)n") nil (concat "R tail: " obj-name))))
("str" . (lambda(obj-name)
(ess-execute (concat "str(" obj-name ")n") nil (concat "R str: " obj-name))))
("summary" . (lambda(obj-name)
(ess-execute (concat "summary(" obj-name ")n") nil (concat "R summary: " obj-name))))
("view source" . (lambda(obj-name)
(ess-execute (concat "print(" obj-name ")n") nil (concat "R object: " obj-name))))
("dput" . (lambda(obj-name)
(ess-execute (concat "dput(" obj-name ")n") nil (concat "R dput: " obj-name)))))
(volatile)))


;; anything-c-source-R-localの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq anything-c-source-R-local
'((name . "R local objects")
(init . (lambda ()
;; this grabs the process name associated with the buffer
(setq anything-c-ess-local-process-name ess-local-process-name)
;; this grabs the buffer for later use
(setq anything-c-ess-buffer (current-buffer))))
(candidates . (lambda ()
(let (buf)
(condition-case nil
(with-temp-buffer
(progn
(setq buf (current-buffer))
(with-current-buffer anything-c-ess-buffer
(ess-command "print(ls.str(), max.level=0)n" buf))
(split-string (buffer-string) "n" t)))
(error nil)))))
(display-to-real . (lambda (obj-name) (car (split-string obj-name " : " t))))
(action
("str" . (lambda(obj-name)
(ess-execute (concat "str(" obj-name ")n") nil (concat "R str: " obj-name))))
("summary" . (lambda(obj-name)
(ess-execute (concat "summary(" obj-name ")n") nil (concat "R summary: " obj-name))))
("head (10)" . (lambda(obj-name)
(ess-execute (concat "head(" obj-name ", n = 10)n") nil (concat "R head: " obj-name))))
("head (100)" . (lambda(obj-name)
(ess-execute (concat "head(" obj-name ", n = 100)n") nil (concat "R head: " obj-name))))
("tail" . (lambda(obj-name)
(ess-execute (concat "tail(" obj-name ", n = 10)n") nil (concat "R tail: " obj-name))))
("print" . (lambda(obj-name)
(ess-execute (concat "print(" obj-name ")n") nil (concat "R object: " obj-name))))
("dput" . (lambda(obj-name)
(ess-execute (concat "dput(" obj-name ")n") nil (concat "R dput: " obj-name)))))
(volatile)))
