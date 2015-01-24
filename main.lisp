(in-package :org.kjerkreit.sudoku-solver)

(defvar *boards*)

(defun solve ()

    (let ((puzzle-count 0)
         (search-free-count 0))
     (loop for board in *boards*
        do (progn
             (incf puzzle-count)
             (pre-proc-board board)
             (if (< (board-found-vals board) 81)
                 (search-board board)
                 (incf search-free-count))))

   (values puzzle-count search-free-count)))

(defun run-solver (fname &optional (n 10) (time nil))

  (unless (probe-file fname)
    (error "no such file"))

  (format t "loading ~a puzzles from ~a~%" n fname)

  (setf *boards* (load-puzzles fname n))

  (format t "calling (solve)~%~%")
  (multiple-value-bind (tot sf) (if time
                                    (time (solve))
                                    (solve))
    (format t "of a total of ~a puzzles ~a were solved without search~%" tot sf)))

(defun main ()
  (cond ((= 1 (list-length sb-ext:*posix-argv*))
         (format t "load from which file and how many (optional)?: ~a <file> [<number of puzzles>]"
                 (car sb-ext:*posix-argv*)))
        ((= 2 (list-length sb-ext:*posix-argv*))
         (run-solver (cadr sb-ext:*posix-argv*)))
        (t
         (run-solver (cadr sb-ext:*posix-argv*) (caddr sb-ext:*posix-argv*) t)))

  (sb-ext:exit))
