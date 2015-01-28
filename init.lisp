(in-package :org.kjerkreit.sudoku-solver)

(defconstant +cell-to-box-map+ '((0 0) (0 1) (0 2) (1 0) (1 1) (1 2) (2 0) (2 1) (2 2)
                                 (0 3) (0 4) (0 5) (1 3) (1 4) (1 5) (2 3) (2 4) (2 5)
                                 (0 6) (0 7) (0 8) (1 6) (1 7) (1 8) (2 6) (2 7) (2 8)
                                 (3 0) (3 1) (3 2) (4 0) (4 1) (4 2) (5 0) (5 1) (5 2)
                                 (3 3) (3 4) (3 5) (4 3) (4 4) (4 5) (5 3) (5 4) (5 5)
                                 (3 6) (3 7) (3 8) (4 6) (4 7) (4 8) (5 6) (5 7) (5 8)
                                 (6 0) (6 1) (6 2) (7 0) (7 1) (7 2) (8 0) (8 1) (8 2)
                                 (6 3) (6 4) (6 5) (7 3) (7 4) (7 5) (8 3) (8 4) (8 5)
                                 (6 6) (6 7) (6 8) (7 6) (7 7) (7 8) (8 6) (8 7) (8 8)))

(defun construct-board (puzzle)
  "Takes a list of ints and uses them to set up a sudoku board"

  (let* ((board (make-board))
         (cells (board-cells board))
         (rows  (board-rows board))
         (cols  (board-cols board))
         (boxes (board-boxes board)))
    
    (dotimes (i 9)
      (aset rows i (make-element))
      (aset cols i (make-element))
      (aset boxes i (make-element)))

    (dotimes (i 81)
      (aset cells i (make-cell)))
    
    (loop for c-value in puzzle
       for (box-n box-p) in +cell-to-box-map+
       for c-num from 0
       for cell = (aref cells c-num)
       for (row-value col-value) = (multiple-value-list (floor c-num 9))
       for row = (aref rows row-value)
       for col = (aref cols col-value)
       for box = (aref boxes box-n)
       do (progn
            (aset (element-cells row) col-value c-num)
            (aset (element-cells col) row-value c-num)
            (aset (element-cells box) box-p c-num)

            (when (/= 0 c-value)
              (incf (board-found-vals board))
              (setf (cell-domain cell) #*000000000)
              (setf (cell-value cell) c-value)

              (setf (sbit (element-found-vals row) c-value))
              (setf (sbit (element-found-vals col) c-value))
              (setf (sbit (element-found-vals box) c-value)))
            (setf (cell-row cell) row-value)
            (setf (cell-col cell) col-value)
            (setf (cell-box cell) box-n)))
    board))

(defmacro load-puzzles (fname &optional (n 10))
    `(mapcar #'construct-board (read-puzzles ,fname ,n)))
