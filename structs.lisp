(in-package :org.kjerkreit.sudoku-solver.structs)

(defstruct cell
  (row)
  (column)
  (box)
  (vals (bit-vector)))

(defstruct element
  (found-vals (bit-vector t))
  (cells))

(defstruct board
  (rows (elt-vector))
  (columns (elt-vector))
  (boxes (elt-vector))
  (cells (cell-vector 81)))
