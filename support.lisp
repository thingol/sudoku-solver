(in-package :org.kjerkreit.sudoku-solver)

(defun concat-strings (list)
  "A non-recursive function that concatenates a list of strings."
  (if (listp list)
      (with-output-to-string (s)
         (dolist (item list)
           (if (stringp item)
             (format s "~a" item))))))

(defun string-to-ints (string)
  (loop for c across string
       collect (string c) into ints
       finally (return (mapcar #'parse-integer ints))))

(defun read-puzzle (fname)
  (with-open-file (s fname :direction :input)
           (loop for line = (read-line s nil nil)
              until (eq line nil)
              collect line into lines
              finally (return (string-to-ints (concat-strings lines))))))

