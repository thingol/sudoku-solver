(in-package :org.kjerkreit.sudoku-solver)

(defparameter *board*)

(defconstant +val-to-board-map+ '((0 (0 0) (0 0) (0 0))
                                  (1 (0 1) (1 0) (0 1))
                                  (2 (0 2) (2 0) (0 2))
                                  (3 (0 3) (3 0) (1 0))
                                  (4 (0 4) (4 0) (1 1))
                                  (5 (0 5) (5 0) (1 2))
                                  (6 (0 6) (6 0) (2 0))
                                  (7 (0 7) (7 0) (2 1))
                                  (8 (0 8) (8 0) (2 2))))



(defun construct-board (puzzle)
  "Takes a list of ints and uses them to set up a sudoku board"

  (let* ((board (make-board))
         (rows  (board-rows board))
         (col   (board-cols board))
         (boxes (board-boxes board)))
    (dolist (cell-val puzzle)
      (multiple-value-bind (div rest) (floor cell-val 9)
        (setf (aref rows 
