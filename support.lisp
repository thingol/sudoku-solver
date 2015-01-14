(in-package :org.kjerkreit.sudoku-solver)

(defun concat-strings (list)
  "A non-recursive function that concatenates a list of strings."

  (log:trace "entry")
  (if (listp list)
      (with-output-to-string (s)
         (dolist (item list)
           (if (stringp item)
             (format s "~a" item))))))

(defun string-to-ints (string)
  "Converts a string to a list of single digit ints."

  (log:trace "entry")
  (loop for c across string
       collect (string c) into ints
       finally (return (mapcar #'parse-integer ints))))

(defun read-puzzle (fname)
  "Read a sudoku puzzle from disk."

  (log:trace "entry")
  (with-open-file (s fname :direction :input)
           (loop for line = (read-line s nil nil)
              until (eq line nil)
              collect line into lines
              finally (return (string-to-ints (concat-strings lines))))))

;; needs to be turned into a macro
(defun get-row (board index)
  "Returns the actual row."

  (aref (board-rows board) index))

(defun get-col (board index)
  "Returns the actual column."

  (aref (board-cols board) index))

(defun get-box (board index)
  "Returns the actual box."

  (aref (board-boxes board) index))

(defmacro aset (array subscript value)
  `(setf (aref ,array , subscript) ,value))
