(in-package :org.kjerkreit.sudoku-solver)

(defvar *boards*)

(defun main ()
  (setf *boards* (load-puzzles "test"))

  (loop for board in *boards*
       do (progn
            (pre-proc-board board)
            (if (< (board-found-vals board) 81)
                (progn
                  (format t "filled in ~a cells, searching for the rest~%" (board-found-vals board))
                  (search-board board))
                (format t "all cells filled in, no search necessary!~%")))))
                
