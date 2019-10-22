;;; sql-sqlline --- Adds Sqlline support to SQLi mode. -*- lexical-binding: t -*-

;; Copyright (C) since 2018 Katherine Cox-Buday
;; Author: Katherine Cox-Buday <cox.katherine.e@gmail.com>
;; Version: 1.0.0
;; Keywords: sql sqlline database
;; Package-Requires: ((emacs "24.4"))


;;; Commentary:
;; * What is it?

;;   Emacs comes with a SQL interpreter which is able to open a connection
;;   to databases and present you with a prompt you are probably familiar
;;   with (e.g. `mysql>', `pgsql>', `sqlline>', etc.). This mode gives you
;;   the ability to do that for Sqlline.


;; * How do I get it?

;;   The canonical repository for the source code is
;;   [https://github.com/kat-co/sql-sqllinedb].

;;   The recommended way to install the package is to utilize Emacs's
;;   `package.el' along with MELPA. To set this up, please follow MELPA's
;;   [getting started guide], and then run `M-x package-install
;;   sql-sqlline'.


;;   [getting started guide] https://melpa.org/#/getting-started


;; * How do I use it?

;;   Within Emacs, run `M-x sql-sqlline'. You will be prompted by in the
;;   minibuffer for a server. Enter the correct server and you should be
;;   greeted by a SQLi buffer with a `sqlline>' prompt.

;;   From there you can either type queries in this buffer, or open a
;;   `sql-mode' buffer and send chunks of SQL over to the SQLi buffer with
;;   the requisite key-chords.


;; * Contributing

;;   Please open GitHub issues and issue pull requests. Prior to submitting
;;   a pull-request, please run `make'. This will perform some linting and
;;   attempt to compile the package.


;; * License

;;   Please see the LICENSE file.

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

(defcustom sql-sqlline-login-params '(server default-catalog default-schema)
  "Parameters needed to connect to Sqlline."
  :type 'sql-login-params
  :group 'sql-sqlline)

(defcustom sql-sqlline-options '("--output-format" "CSV_HEADER")
  "List of options for `sql-sqlline-program'."
  :type '(repeat string)
  :group 'sql-sqlline)

(defun sql-sqlline-comint (product options &optional buffer-name)
  "Connect to Sqlline in a comint buffer.

PRODUCT is the sql product (sqlline). OPTIONS are any additional
options to pass to sqlline-shell. BUFFER-NAME is what you'd like
the SQLi buffer to be named."
  (let ((params (append (unless (string= "" sql-server)
                          `("--server" ,sql-server))
                        (unless (string= "" sql-database)
                          `("--catalog" sql-database))
                        options)))
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
