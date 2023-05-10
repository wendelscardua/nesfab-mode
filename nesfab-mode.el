;;; nesfab-mode.el --- Major mode for NESFab source files -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Wendel Scardua

;; Author: Wendel Scardua <wendel@scardua.net>
;; Keywords: languages, NESFab, 6502
;; Version: 0.0.1
;; Homepage: https://github.com/wendelscardua/nesfab-mode
;; Package-Requires: ((emacs "26.1"))

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Affero General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU Affero General Public
;; License along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides font-locking and indentation support to NESFab source files.

;;; Code:

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.fab\\'" . nesfab-mode))

(defvar nesfab-keywords
  '("if" "else" "for" "while" "do" "break" "continue" "return"
    "fn" "ct" "nmi" "mode" "goto" "label" "file" "struct" "vars"
    "data" "omni" "ready" "fence" "default" "switch" "case" "asm"
    "charmap" "chrrom" "true" "false" "audio" "system" "stows"
    "employs" "preserves" "state")

  "NESFab language keywords.")

(defvar nesfab-types-regexp
  (rx (and
       word-start
       (or
        ;; constant stuff
        "Int"
        "Real"
        "Bool"
        "Void"
        ;; variable scalars
        "U" "UU" "UUU" "S" "SS" "SSS"
        "F" "FF" "FFF"
        (and
         (or "U" "UU" "UUU" "S" "SS" "SSS")
         (or "F" "FF" "FFF")
         )
        ;; pointers
        "CC"
        "CCC"
        "MM"
        "MMM"
        )
       word-end))

  "NESFab language types regexp.")

(defvar nesfab-groups-regexp
  (rx (one-or-more word))

  "NESFab language groups regexp.")

(defvar nesfab-constants-regexp
  (rx (and
       word-start
       (or
        (and "$" (one-or-more (any hex-digit)))
        (and (opt (any "-+"))
             (one-or-more (any digit)))
        (and "%" (one-or-more (any "01"))))
       word-end))
  "NESFab language constants regexp.")

(defconst nesfab-keywords-regexp
  (regexp-opt nesfab-keywords 'symbols)

  "Regular expression matching NESFab keywords.")

(defconst nesfab-font-lock-keywords
  `(
    (,nesfab-types-regexp . font-lock-type-face)
    (,nesfab-keywords-regexp . font-lock-keyword-face)
    (,nesfab-constants-regexp . font-lock-constant-face)
    (,nesfab-groups-regexp . font-lock-variable-name-face)
    )

  "Font lock keywords for NESFab.")

(defvar nesfab-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\' "\"'"  table)
    (modify-syntax-entry ?\" "\"\"" table)
    (modify-syntax-entry ?` "\"`" table)
    (modify-syntax-entry ?/ ". 124" table)
    (modify-syntax-entry ?* ". 23b" table)
    (modify-syntax-entry ?\n ">" table)
    table)

  "Syntax table in use in `nesfab-mode' buffers.")

(define-derived-mode nesfab-mode prog-mode "NESFab"
  "Major mode for editing NESFab files."

  (setq-local font-lock-defaults `(nesfab-font-lock-keywords))
  (setq-local comment-start "/*")
  (setq-local comment-start-skip "/\\*+[ \t]*")
  (setq-local comment-end "*/")
  (setq-local comment-end-skip "[ \t]*\\*+/")
  )
(provide 'nesfab-mode)

;;; nesfab-mode.el ends here
