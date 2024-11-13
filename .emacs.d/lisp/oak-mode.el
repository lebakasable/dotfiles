;;; oak-mode.el --- Major Mode for editing Oak source code. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Major Mode for editing Oak source code.

(defconst oak-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    (modify-syntax-entry ?# ".")
    (modify-syntax-entry ?' "\"")
    (modify-syntax-entry ?+ ".")
    (modify-syntax-entry ?- ".")
    (modify-syntax-entry ?* ".")
    (modify-syntax-entry ?/ ".")
    (modify-syntax-entry ?% ".")
    (modify-syntax-entry ?< ".")
    (modify-syntax-entry ?> ".")
    (syntax-table))
  "Syntax table for `oak-mode'.")

(defun oak-syntax-propertize (start end)
  (goto-char start)
  (funcall
   (syntax-propertize-rules
    ("\\(##\\)[^#]*\\(#\\)" (1 "<") (2 ">"))
    ("\\(#\\)[^\n]*\\(\n\\)" (1 "<") (2 ">")))
   start end))

(defconst oak-highlights
  `((,(eval-when-compile
        (regexp-opt
         '("if" "else" "for" "match" "break" "return"
           "sizeof" "assert" "as" "use" "fn" "let"
           "const" "alias" "struct" "print")
         'symbols)) . font-lock-keyword-face)
    ("\\_<\\([0-9]+\\|[A-Z][A-Z0-9_]*\\|true\\|false\\)\\_>" . (1 font-lock-constant-face))
    ("\\_<\\([A-Z][A-Za-z0-9_]*\\|int\\|char\\|bool\\)\\_>" . (1 font-lock-type-face))
    ("\\([A-Za-z_][A-Za-z0-9_]*\\)\\s-*(" . (1 font-lock-function-name-face))))

(defun oak--previous-non-empty-line ()
  (save-excursion
    (forward-line -1)
    (while (and (not (bobp))
                (string-empty-p
                 (string-trim-right
                  (thing-at-point 'line t))))
      (forward-line -1))
    (thing-at-point 'line t)))

(defun oak--indentation-of-previous-non-empty-line ()
  (save-excursion
    (forward-line -1)
    (while (and (not (bobp))
                (string-empty-p
                 (string-trim-right
                  (thing-at-point 'line t))))
      (forward-line -1))
    (current-indentation)))

(defun oak--desired-indentation ()
  (let* ((cur-line (string-trim-right (thing-at-point 'line t)))
         (prev-line (string-trim-right (oak--previous-non-empty-line)))
         (prev-indent (oak--indentation-of-previous-non-empty-line)))
    (cond
     ((and (string-suffix-p "{" prev-line)
           (string-prefix-p "}" (string-trim-left cur-line)))
      prev-indent)
     ((string-suffix-p "{" prev-line)
      (+ prev-indent tab-width))
     ((string-prefix-p "}" (string-trim-left cur-line))
      (max (- prev-indent tab-width) 0))
     (t prev-indent))))

(defun oak-indent-line ()
  (interactive)
  (when (not (bobp))
    (let* ((desired-indentation
            (oak--desired-indentation))
           (n (max (- (current-column) (current-indentation)) 0)))
      (indent-line-to desired-indentation)
      (forward-char n))))

;;;###autoload
(define-derived-mode oak-mode prog-mode "Oak"
  "Major Mode for editing Oak source code."
  :syntax-table oak-mode-syntax-table
  (setq-local syntax-propertize-function #'oak-syntax-propertize)
  (setq font-lock-defaults '(oak-highlights))
  (setq-local comment-start "# ")
  (set (make-local-variable 'indent-line-function) 'oak-indent-line))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.oak\\'" . oak-mode))

(provide 'oak-mode)
;;; oak-mode.el ends here
