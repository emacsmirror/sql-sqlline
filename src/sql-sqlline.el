;;; sql-sqlline.el --- Adds SQLLine support to SQLi mode -*- lexical-binding: t -*-

;; Copyright (C) since 2019 Matteo Redaelli
;; Author: Matteo Redaelli <matteo.redaelli@gmail.com>

;; Version: 1.0.2
;; Keywords: languages
;; Package-Requires: ((emacs "27.1"))
;; Homepage: https://gitlab.com/matteoredaelli/sql-sqlline

;; This file is not part of GNU Emacs.

;; This file is free software...

;;; Commentary:
;; $$COMMENTARY$$

;;; Code:
(require 'sql)

(defgroup sql-sqlline nil
  "Use SQLLine with sql-interactive mode."
  :group 'SQL
  :prefix "sql-sqlline-")

(defcustom sql-sqlline-program "sqlline"
  "Command to start the SQLLine command interpreter."
  :type 'file
  :group 'sql-sqlline)

(defcustom sql-sqlline-login-params '()
  "Parameters needed to connect to SQLLine."
  :type 'sql-login-params
  :group 'sql-sqlline)

(defcustom sql-sqlline-options '("--silent" "true")
  "List of options for `sql-sqlline-program'."
  :type '(repeat string)
  :group 'sql-sqlline)

(defun sql-sqlline-comint (product options &optional buffer-name)
  "Connect to SQLLine in a comint buffer.

PRODUCT is the sql product (sqlline).  OPTIONS are any additional
options to pass to sqlline-shell.  BUFFER-NAME is what you'd like
the SQLi buffer to be named."
  "Connect to SQLLine in a comint buffer.

PRODUCT is the sql product (sqlline). OPTIONS are any additional
options to pass to sqlline-shell. BUFFER-NAME is what you'd like
the SQLi buffer to be named."
    (sql-comint product options buffer-name))

;;;###autoload
(defun sql-sqlline (&optional buffer)
  "Run SQLLine as an inferior process.

The buffer with name BUFFER will be used or created."
  (interactive "P")
  (sql-product-interactive 'sqlline buffer))

(sql-add-product 'sqlline "SQLLine"
		 '(:free-software t))

(sql-set-product-feature 'sqlline
			 :list-all "!tables")
(sql-set-product-feature 'sqlline
			 :list-table "!describe %s;")
(sql-set-product-feature 'sqlline
			 :prompt-regexp "^[^>]*> ")
(sql-set-product-feature 'sqlline
			 :prompt-cont-regexp "^(semicolon|quote|dquote)> ")
;;(sql-set-product-feature 'sqlline
;;			 :sqli-comint-func 'sql-sqlline-comint)
(sql-set-product-feature 'sqlline
			 :font-lock 'sql-mode-ansi-font-lock-keywords)
(sql-set-product-feature 'sqlline
			 :sqli-login sql-sqlline-login-params)
(sql-set-product-feature 'sqlline
			 :sqli-program 'sql-sqlline-program)
(sql-set-product-feature 'sqlline
			 :sqli-options 'sql-sqlline-options)

(provide 'sql-sqlline)
;;; sql-sqlline.el ends here
