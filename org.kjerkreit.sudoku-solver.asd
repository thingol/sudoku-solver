;;; -*- Lisp -*-

(in-package :asdf)

(defsystem org.kjerkreit.sudoku-solver
  :version "0.0.0"
  :author "Marius Hårstad Bauer-Kjerkreit"
  :license "BSD-style"
  :components ((:static-file "LICENSE")
	       (:file "package")
               (:file "misc" :depends-on ("package"))
               (:file "structs" :depends-on ("structs"))))
