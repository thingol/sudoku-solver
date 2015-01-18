(in-package :org.kjerkreit.sudoku-solver)

(defun shave (cell board)
  "Returns a copy of the domain of a cell, sans values already found in the
elements it belongs to."

  ;; ugly fugly
  (let ((domain (cell-domain cell)))
    (if domain
        (progn
          (setf domain (set-difference domain
                                       (element-found-vals (get-row board cell))))
          (setf domain (set-difference domain
                                       (element-found-vals (get-col board (cell-col cell)))))
          (set-difference domain
                          (element-found-vals (get-box board (cell-box cell)))))
        domain)))
  
(defun shave-board (board)
  "Calls (shave cell board) for all cells."

  (map nil #'(lambda (cell)
               (setf (cell-domain cell)
                     (shave cell board)))
       (board-cells board)))

(defun find-single-vals (board)
  (declare (optimize (debug 3)))

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

(defun get-free-cells (board)
  "Returns a vector with all free cells sorted by most-constrained."
  (declare (optimize (debug 3)))

  (sort (remove-if #'(lambda (cell)
                       (/= (cell-value cell) 0))
                   (board-cells board))
        #'(lambda (list0 list1)
            (<= (list-length list0) (list-length list1)))
        :key #'cell-domain))


(defun check-value (board cell value)
  (declare (optimize (debug 3)))


  (not (or (member value (element-found-vals (get-row board cell)) :test #'=)
           (member value (element-found-vals (get-col board (cell-col cell))) :test #'=)
           (member value (element-found-vals (get-box board (cell-box cell))) :test #'=))))

(defun pop-value (board cell)
  (declare (optimize (debug 3)))
  
  (setf (cell-value cell) 0)
  
  (pop (element-found-vals (get-row board cell)))
  (pop (element-found-vals (get-col board (cell-col cell))))
  (pop (element-found-vals (get-box board (cell-box cell)))))

(defun push-value (board cell value)
  (declare (optimize (debug 3)))

  (setf (cell-value cell) value)
  
  (push value (element-found-vals (get-row board cell)))
  (push value (element-found-vals (get-col board (cell-col cell))))
  (push value (element-found-vals (get-box board (cell-box cell)))))
