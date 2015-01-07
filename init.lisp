(in-package :org.kjerkreit.sudoku-solver)

(defparameter *board*)

(defconstant +cell-to-box-map+ '((0 0) (0 1) (0 2) (1 0) (1 1) (1 2) (2 0) (2 1) (2 2)
                                 (0 3) (0 4) (0 5) (1 3) (1 4) (1 5) (2 3) (2 4) (2 5)
                                 (0 6) (0 7) (0 8) (1 6) (1 7) (1 8) (2 6) (2 7) (2 8)
                                 3 3 3 4 4 4 5 5 5
                                 3 3 3 4 4 4 5 5 5
                                 3 3 3 4 4 4 5 5 5
                                 6 6 6 7 7 7 8 8 8
                                 6 6 6 7 7 7 8 8 8
                                 6 6 6 7 7 7 8 8 8))

#|
    0         1         2
 0  1  2  3   4  5   6  7  8
 9 10 11  12 13 14  15 16 17
18 19 20  21 22 23  24 25 26

    3         4         5
27 28 29  30 31 32  33 34 35
36 37 38  39 40 41  42 43 44
45 46 47  48 49 50  51 52 53

    6         7         8
54 55 56  57 58 59  60 61 62
63 64 65  66 67 68  69 70 71
72 73 74  75 76 77  78 79 80
|#


(defun construct-board (puzzle)
  "Takes a list of ints and uses them to set up a sudoku board"

  (let* ((board (make-board))
         (cells (board-cells board))
         (rows  (board-rows board))
         (cols  (board-cols board))
         (boxes (board-boxes board)))
    (loop for cell-val in puzzle
      for (box-n box-p) in +cell-to-box-map+
      for count from 0
      for cell = (aref cells count)
      for (div rest) = (multiple-value-list (floor count 9))
      for row = (aref rows div)
      for col = (aref cols rest)
      for box = (aref boxes box-n)
      do (progn
           (when (/= 0 cell-val)
             (setf (cell-domain cell) 0)
             (setf (cell-value cell) cell-val))
           
          (setf (aref row rest) cell)
          (setf (aref col div) cell)
          (setf (aref box box-p) cell)
          
          (setf (cell-row cell) row)
          (setf (cell-col cell) col)
          (setf (cell-box cell) box)
           ))
    board))

    
#|         (count 0))
    (dolist (cell-val puzzle)
      (multiple-value-bind (div rest) (floor count 9)
        (let ((cell (aref cells count))
              (row (aref rows div))
              (col (aref cols rest)))
          (when (/= 0 cell-val)
            (setf (cell-domain cell) 0)
            (setf (cell-value cell) cell-val))
          (setf (aref row rest) cell)
          (setf (aref col div) cell)
          (setf (cell-row cell) row)
          (setf (cell-col cell) col)
        )))))
|#
    
