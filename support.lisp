(in-package :org.kjerkreit.sudoku-solver)

(defun bit-vector (&optional (found nil))

  (make-array 9
              :element-type 'bit
              :initial-element (if found nil t)
              :adjustable nil
              :fill-pointer nil))

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

(defun read-puzzle ())

