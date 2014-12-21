(in-package :org.kjerkreit.sudoku-solver.support)

(defmacro gen-elements ()
  "Creates a 2-dim array that represents the rows, columns or boxes of the sudoku board."
  (make-array (9 9)
              :element-type 'cell
              :initial-element nil
              :adjustable nil
              :fill-pointer nil))
