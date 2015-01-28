(in-package :org.kjerkreit.sudoku-solver)

(defun check-value (board cell value)
  "Checks wether value is legal for cell."
  (declare (optimize (speed 3) (debug 0) (safety 0) (space 0))
           (type board board)
           (type cell cell)
           (type (integer 1 9) value))

  (not (or (= (sbit (element-found-vals (get-row board cell)) value) 1)
           (= (sbit (element-found-vals (get-col board cell)) value) 1)
           (= (sbit (element-found-vals (get-box board cell)) value) 1))))

(defun domainp (domain)
  (declare (optimize (speed 3) (debug 0) (safety 0) (space 0))
           (type (simple-bit-vector 9) domain))

  (loop for b across domain
       do (when (= b 1)
            (return t))))

(defun get-free-cells (board)
  "Returns a vector with all free cells sorted by most-constrained."

  (sort (remove-if #'(lambda (cell)
                       (/= (cell-value cell) 0))
                   (board-cells board))
        #'(lambda (list0 list1)
            (<= (length list0) (length list1)))
        :key #'cell-domain))

(defun get-single-val (domain)
  ;;(declare (optimize (speed 3) (debug 0) (safety 0) (space 0))
  (declare (optimize (speed 0) (debug 3) (safety 3) (space 0))
           (ftype (function (simple-bit-vector 9) (integer 1)) get-single-val))
  
  (loop for b across domain
     for i from 1
     do (when (= b 1)
          (return i))))

(defun pop-value (board cell)

  (let ((value (cell-value cell)))
    (setf (cell-value cell) 0)

    (setf (sbit (element-found-vals (get-row board cell)) value) 0)
    (setf (sbit (element-found-vals (get-col board cell)) value) 0)
    (setf (sbit (element-found-vals (get-box board cell)) value) 0)))

(defun push-value (board cell value)

  (setf (cell-value cell) value)
  (setf (sbit (element-found-vals (get-row board cell)) value) 1)
  (setf (sbit (element-found-vals (get-row board cell)) value) 1)
  (setf (sbit (element-found-vals (get-row board cell)) value) 1))

(defun single-valp (domain)
  ;;(declare (optimize (speed 3) (debug 0) (safety 0) (space 0))
  (declare (optimize (speed 0) (debug 3) (safety 3) (space 0))
           (type (simple-bit-vector 9) domain))

  (let ((bits 0))
    (declare (type (integer 0 2) bits))
    (loop for b across domain
       do (progn
            (when (= b 1)
              (incf bits))
            (when (> bits 1)
              (return nil)))))
  t)

(defun shave-board (board)
  "Removes illegal values from the domains of cells."
  (declare (ftype (function (board) nil) board)
           (inline domainp))

  (flet ((shave (cell)
           (let ((domain (cell-domain cell)))
             (when (domainp domain)
               (bit-andc1 
                (bit-ior
                 (element-found-vals (get-row board cell))
                 (bit-ior
                  (element-found-vals (get-col board cell))
                  (element-found-vals (get-box board cell))))
                domain domain)))))
    (map nil #'shave (board-cells board))))

(defun find-single-vals (board)
  "Find and sets value for cell with single member domain."

  ;; ugly fugly
  (let ((found nil))
    (map nil #'(lambda (cell)
                 (let ((domain (cell-domain cell)))
                   (when (single-valp domain)
                     (push-value  (element-found-vals (get-row board cell)))
                     (push (car domain) (element-found-vals (get-col board cell)))
                     (push (car domain) (element-found-vals (get-box board cell)))
                     (setf (cell-value cell) (car domain))
                     (setf (cell-domain cell) nil)
                     (incf (board-found-vals board))
                     (setf found t))))
         (board-cells board))
    found)))

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
