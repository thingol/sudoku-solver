(in-package :org.kjerkreit.sudoku-solver)

(defstruct cell
  (row nil)
  (col nil)
  (box nil)
  (value 0)
  (domain 512));; :type (unsigned-byte 9)))

(defstruct element
  (found-vals 0)
  (cells (cell-vector)))

(defun cell-vector (&optional (board nil))

  (make-array (if board 81 9)
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
  (cells (cell-vector t)))
