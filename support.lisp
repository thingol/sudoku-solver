(in-package :org.kjerkreit.sudoku-solver)

(defun concat-strings (list)
  "A non-recursive function that concatenates a list of strings."

  (if (listp list)
      (with-output-to-string (s)
         (dolist (item list)
           (if (stringp item)
             (format s "~a" item))))))

(defun string-to-ints (string)
  "Converts a string to a list of single digit ints."

  (loop for c across string
       collect (string c) into ints
       finally (return (mapcar #'parse-integer ints))))

(defun read-puzzles (fname n)
  "Read a sudoku puzzle from disk."

  (with-open-file (s fname :direction :input)
           (loop for line = (read-line s nil nil)
              for i from 1 to (parse-integer n)
              until (eq line nil)
              collect (string-to-ints line) into lines
              finally (return lines))))

(defun print-board (board)
  (loop
     for row across (board-rows board)
     do (loop
           for cell across (element-cells row)
           collect (cell-value (svref (board-cells board) cell)) into value-list
           finally (format t "~{ ~a~^ ~} ~%" value-list))))

(defmacro get-row (board cell)
  "Returns the actual row."

  `(aref (board-rows ,board) (cell-row ,cell)))

(defmacro get-col (board cell)
  "Returns the actual column."

  `(aref (board-cols ,board) (cell-col ,cell)))

(defmacro get-box (board cell)
  "Returns the actual box."

  `(aref (board-boxes ,board) (cell-box ,cell)))

(defmacro aset (array subscript value)
  "Counterpart to aref, which should on reflection probably be called 'getref' or something..."
  
  `(setf (aref ,array , subscript) ,value))
