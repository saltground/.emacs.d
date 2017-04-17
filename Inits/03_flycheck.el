;; flycheck
(require 'flycheck)
(require 'flycheck-pos-tip)

(eval-after-load 'flycheck
  '(custom-set-variables
   '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

(add-hook 'R-mode-hook 'flycheck-mode)
(add-hook 'ruby-mode-hook 'flycheck-mode)
(add-hook 'c-mode-common-hook 'flycheck-mode)

(require 'helm-flycheck) ;; Not necessary if using ELPA package
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-+") 'helm-flycheck))

(flycheck-define-checker c/c++
  "A C/C++ checker using g++."
  :command ("g++" "-Wall" "-Wextra" source)
  :error-patterns  ((error line-start
                           (file-name) ":" line ":" column ":" " エラー: " (message)
                           line-end)
                    (warning line-start
                           (file-name) ":" line ":" column ":" " 警告: " (message)
                           line-end))
  :modes (c-mode c++-mode))

