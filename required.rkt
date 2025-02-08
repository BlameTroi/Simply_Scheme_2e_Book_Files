#lang simply-scheme

;;; required.rkt -- standard environment setup for _Simply_Scheme_

;; If you are using R5RS Scheme such as Chicken 5, see file 
;; "required.scm". This file is a rework of that file for Racket,
;; but all you really need is to set the language to simply-scheme,
;; but are more details:

;;; Commentary:

;; The authors provide a standard set of abstractions and a few sample
;; projects. The standard abstractions are a consistent requirement as
;; you work through the text.
;;
;; If you are using Racket, this is accomplished by setting the
;; langauge to simply-scheme. I prefer to do this in source as
;; "#lang simply-scheme". This language and the language for SICP are
;; not installed by default, Use the Racket package manager to install
;; them.
;;
;; I have found it helpful to load a couple of other libraries.
;;
;; Troy Brumley -- blametroi@gmail.com -- Feburary 2025.


;;; Environment Requirements:

;; An R5RS Scheme, such as Chicken, and the "simply.scm" file are
;; all you need.


;;; Code:


;;; simply.scm -- the _Simply_Scheme_ abstraction layer:

(load "simply.scm")


;;; Additional environment setup:

;;; srfi-78 -- extremely lightweight testing:

;; My personal style of development is to have many small tests. The
;; framework in srfi-78 is very lightweight, requiring nor providing
;; for any real setup. This gives enough "test first" goodness without
;; significant overhead. It can be as simple as "(check (some
;; function) => expected result)"
;;
;; This srfi appears to be one of those installed by default in Racket.

(require srfi/78)


;;; trace -- runtime tracing:

;; Around chapter 13 the authors begin to expose details of recursion
;; and they use trace to do so. A trace function matching the one
;; described in the text is part of the simply-scheme langauge, so
;; all you need to do turn tracing of a procedure on or off:
;;
;; (trace procedure)
;; (untrace procedure)


;;; Examples and projects:

;; Any of the following can be uncommented to work with that
;; particular set of procedures in the text. Or more simply, just type
;; the load command into the repl after this file has been loaded.
;;
;; In my limited testing, these don't all play together nicely and the
;; authors did not mean for anyone to load all of these at once. I
;; treat simply.scm as a prereq for any one of the following, and if I
;; switch from say functions.scm to ttt.scm, I restart the REPL
;; session.
;;
;; (load "functions.scm")
;; (load "spread.scm")
;; (load "match.scm")  ;; currently does not work.
;; (load "ttt.scm")
;; (load "newttt.scm") ;; another version from the author's site.
;; (load "database.scm")

;;; required.rkt ends here.
