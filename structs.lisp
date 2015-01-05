(in-package :org.kjerkreit.sudoku-solver)

(defstruct cell
  (row nil)
  (column nil)
  (box nil)
  (vals 512 :type (unsigned-byte 9)))

(defstruct element
  (found-vals 0)
  (cells (cell-vector)))

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
  (columns (elt-vector))
  (boxes (elt-vector))
  (cells (cell-vector)))
