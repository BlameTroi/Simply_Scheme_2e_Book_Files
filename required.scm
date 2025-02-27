;;; required.scm -- standard environment setup for _Simply_Scheme_

;; If you are Racket, see file "required.rkt". The setup is a bit
;; simpler, not that this is complex.

;;; Commentary:

;; The authors provide a standard set of abstractions and a few sample
;; projects. The standard abstractions are a consistent requirement as
;; you work through the text.
;;
;; If you are using an R5RS Scheme, review this file and then load
;; it into that Scheme.
;;
;; I have found it helpful to load a couple of other libraries.
;;
;; Troy Brumley -- blametroi@gmail.com -- Feburary 2025.

;;; Environment Requirements:

;; An R5RS Scheme, such as Chicken, and the "simply.scm" file are
;; all you need.

;; I've only tried Chez, Guile, and Chicken. The first two don't work.
;; Chicken 5 supports the Scheme langauge as in R5RS which was the
;; active standard when _Simply_Scheme_ was published.


;;; Code:


;;; simply.scm -- the _Simply_Scheme_ abstraction layer:

(load "simply.scm")


;;; Additional environment setup:

;; Chicken makes many packages available via their "chicken-install". I
;; use two regularly: srfi-78 for testing, and trace for a simple
;; execution trace.
;;
;; I don't know the correct commands to grab these for other Scheme
;; implementations.


;;; srfi-78 -- extremely lightweight testing:

;; My personal style of development is to have many small tests. The
;; framework in srfi-78 is very lightweight, requiring nor providing
;; for any real setup. This gives enough "test first" goodness without
;; significant overhead. It can be as simple as "(check (some
;; function) => expected result)"

(import srfi-78)


;;; trace -- runtime tracing:

;; Around chapter 13 the authors begin to expose details of recursion
;; and they use trace to do so. The Chicken trace is pretty simple and
;; after loading the text's directions just work for tracing in the
;; repl.

(import trace)


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

;;; required.scm ends here.
