(in-package :org.kjerkreit.sudoku-solver)

(defun shave-board (board)
  "Removes illegal values from the domains of cells."

  (flet ((shave (cell)
           (let ((domain (cell-domain cell)))
             (when domain
               (setf (cell-domain cell)
                     (set-difference domain
                                     (union (element-found-vals (get-row board cell))
                                            (union (element-found-vals (get-col board cell))
                                                   (element-found-vals (get-box board cell))))))))))
    (map nil #'shave (board-cells board))))

(defun find-single-vals (board)
  "Find and sets value for cell with single member domain."

  ;; ugly fugly
  (let ((found nil))
    (map nil #'(lambda (cell)
                 (let ((domain (cell-domain cell)))
                   (when (= (list-length domain) 1)
                     (push (car domain) (element-found-vals (get-row board cell)))
                     (push (car domain) (element-found-vals (get-col board cell)))
                     (push (car domain) (element-found-vals (get-box board cell)))
                     (setf (cell-value cell) (car domain))
                     (setf (cell-domain cell) nil)
                     (incf (board-found-vals board))
                     (setf found t))))
         (board-cells board))
    found))

(defun search-board (board)
  "Searches for solutions with very simple backtracking mechanism."
  (declare (optimize (debug 3)))

  (let* ((cells (get-free-cells board))
         (i 0)
         (cell-count (length cells)))
    (block bc-loop
      (labels ((recur ()
                 (declare (optimize (debug 3)))
                 
                 (when (= i cell-count)
                   (return-from bc-loop t))

                 (let ((cell (svref cells i)))
        
                   (loop for value in (cell-domain cell)
                      do (when (check-value board cell value)
                           (push-value board cell value)
                           (incf i)
                           (recur)
                           (decf i)
                           (pop-value board cell))))))

        (recur)
        nil))))

(defun pre-proc-board (board)
  "Shave board and look for single value domains until all have been found.
If lucky this will result in a solved puzzle."

  (loop
     do (shave-board board)
     until (not (find-single-vals board))))

(defun get-free-cells (board)
  "Returns a vector with all free cells sorted by most-constrained."

  (sort (remove-if #'(lambda (cell)
                       (/= (cell-value cell) 0))
                   (board-cells board))
        #'(lambda (list0 list1)
            (<= (list-length list0) (list-length list1)))
        :key #'cell-domain))


(defun check-value (board cell value)
  "Checks wether value is legal for cell."

  (not (or (member value (element-found-vals (get-row board cell)) :test #'=)
           (member value (element-found-vals (get-col board cell)) :test #'=)
           (member value (element-found-vals (get-box board cell)) :test #'=))))

(defun pop-value (board cell)
  
  (setf (cell-value cell) 0)
  
  (pop (element-found-vals (get-row board cell)))
  (pop (element-found-vals (get-col board cell)))
  (pop (element-found-vals (get-box board cell))))

(defun push-value (board cell value)

  (setf (cell-value cell) value)
  
  (push value (element-found-vals (get-row board cell)))
  (push value (element-found-vals (get-col board cell)))
  (push value (element-found-vals (get-box board cell))))
