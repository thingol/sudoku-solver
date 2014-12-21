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

(defun concat-strings (list)
  "A non-recursive function that concatenates a list of strings."
  (if (listp list)
      (with-output-to-string (s)
         (dolist (item list)
           (if (stringp item)
             (format s "~a" item))))))

(defun read-puzzle (fname)
  (with-open-file (s fname :direction :input
           (loop for line = (read-line s nil nil)
              until (eq line nil)
              collect line into lines
              finally (return (concat-strings lines))))

