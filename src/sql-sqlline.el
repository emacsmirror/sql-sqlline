;;; sql-sqlline --- Adds Sqlline support to SQLi mode. -*- lexical-binding: t -*-

;; Copyright (C) since 2018 Katherine Cox-Buday
;; Author: Katherine Cox-Buday <cox.katherine.e@gmail.com>
;; Version: 1.0.0
;; Keywords: sql sqlline database
;; Package-Requires: ((emacs "24.4"))


;;; Commentary:
;; $$COMMENTARY$$

;;; Code:
(require 'sql)

(defgroup sql-sqlline nil
  "Use Sqlline with sql-interactive mode."
  :group 'SQL
  :prefix "sql-sqlline-")

(defcustom sql-sqlline-program "sqlline"
  "Command to start the Sqlline command interpreter."
  :type 'file
  :group 'sql-sqlline)

(defcustom sql-sqlline-login-params '()
  "Parameters needed to connect to Sqlline."
  :type 'sql-login-params
  :group 'sql-sqlline)

(defcustom sql-sqlline-options '("--silent" "true")
  "List of options for `sql-sqlline-program'."
  :type '(repeat string)
  :group 'sql-sqlline)

(defun sql-sqlline-comint (product options &optional buffer-name)
  "Connect to Sqlline in a comint buffer.

PRODUCT is the sql product (sqlline). OPTIONS are any additional
options to pass to sqlline-shell. BUFFER-NAME is what you'd like
the SQLi buffer to be named."
  "Connect to Sqlline in a comint buffer.

PRODUCT is the sql product (sqlline). OPTIONS are any additional
options to pass to sqlline-shell. BUFFER-NAME is what you'd like
the SQLi buffer to be named."
  (let (params options)
    (sql-comint product params buffer-name)))

;;;###autoload
(defun sql-sqlline (&optional buffer)
  "Run Sqlline as an inferior process.

The buffer with name BUFFER will be used or created."
  (interactive "P")
  (sql-product-interactive 'sqlline buffer))

(sql-add-product 'sqlline "Sqlline"
                 :free-software t
                 :list-all "!tables"
                 :list-table "!describe %s;"
                 :prompt-regexp "^[^>]*> "
                 :prompt-cont-regexp "^semicolon> "
                 :sqli-comint-func 'sql-sqlline-comint
                 :font-lock 'sql-mode-ansi-font-lock-keywords
                 :sqli-login sql-sqlline-login-params
                 :sqli-program 'sql-sqlline-program
                 :sqli-options 'sql-sqlline-options)

(provide 'sql-sqlline)
;;; sql-sqlline.el ends here
