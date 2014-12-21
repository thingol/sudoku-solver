(in-package :org.kjerkreit.sudoku-solver)

(defun construct-board (puzzle))

(defun string-to-ints (string)
  (loop for c in string as (string c)
       collect c into ints
       finally (return (apply #'parse-integer ints))))
