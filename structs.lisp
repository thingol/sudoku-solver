(in-package :org.kjerkreit.sudoku-solver)

(eval-when (:compile-toplevel :execute :load-toplevel)
  (declaim (sb-ext:muffle-conditions style-warning)))

(defstruct cell
  (row 0 :type (integer 0 8))
  (col 0 :type (integer 0 8))
  (box 0 :type (integer 0 8))
  (value 0 :type (integer 0 9))
  (domain (make-array 9 :element-type 'bit :initial-element 1)))

(defstruct element
  (found-vals (make-array 9 :element-type 'bit :initial-element 0))
  (cells (make-array 9 :element-type 'cell)))

(defstruct board
  (found-vals 0 :type (integer 0 81))
  (rows (make-array 9 :element-type 'element))
  (cols (make-array 9 :element-type 'element))
  (boxes (make-array 9 :element-type 'element))
  (cells (make-array 81 :element-type 'cell)))
