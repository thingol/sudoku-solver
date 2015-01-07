(in-package :org.kjerkreit.sudoku-solver)

(defstruct cell
  (row nil)
  (col nil)
  (box nil)
  (value 0)
  (domain 512))

(defstruct element
  (found-vals 0)
  (cells (make-array 9
                     :element-type 'fixnum
                     :adjustable nil
                     :fill-pointer nil)))

(defun cell-vector ()

  (make-array 81
              :element-type 'cell
              :adjustable nil
              :fill-pointer nil))

(defun elt-vector ()

  (make-array 9
              :element-type 'element
              :adjustable nil
              :fill-pointer nil))

(defstruct board
  (rows (elt-vector))
  (cols (elt-vector))
  (boxes (elt-vector))
  (cells (cell-vector)))
