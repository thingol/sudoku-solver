(in-package :org.kjerkreit.sudoku-solver)

(defstruct cell
  (row 0 :type (integer 0 8))
  (col 0 :type (integer 0 8))
  (box 0 :type (integer 0 8))
  (value 0 :type (integer 0 9))
  (domain '(1 2 3 4 5 6 7 8 9) :type list))

(defstruct element
  (found-vals '() :type list)
  (cells (make-array 9)))

(defstruct board
  (found-vals 0 :type (integer 0 81))
  (rows (make-array 9 :element-type 'element))
  (cols (make-array 9 :element-type 'element))
  (boxes (make-array 9 :element-type 'element))
  (cells (make-array 81 :element-type 'cell)))
