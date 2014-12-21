(in-package :org.kjerkreit.sudoku-solver.structs)

(defstruct cell
  (row)
  (column)
  (box)
  (vals '(1 2 3 4 5 6 7 8 9)))

(defstruct board
  (rows (gen-elements))
  (columns (make-array (9 9)
                       :element-type 'cell
                       :initial-element nil
                       :adjustable nil
                       :fill-pointer nil))
  (boxes (make-array (9 9)
                     :element-type 'cell
                     :initial-element nil
                     :adjustable nil
                     :fill-pointer nil)))
