;; garbage-pools.lisp

(in-package #:garbage-pools)

(defvar *pool*)

;;; pool

(defclass pool ()
  ((register-pairs :initform nil :accessor register-pairs)))

;;; cleanup-register

(defun cleanup-register (object cleanup-fun &optional (pool *pool*))
  (push (cons object cleanup-fun)
        (register-pairs pool))
  object)

;;; cleanup-pool

(defun cleanup-pool (&optional (pool *pool*))
  (iter (for (obj . cleanup-fun) in (register-pairs pool))
        (if (and obj cleanup-fun)
            (funcall cleanup-fun obj)))
  (setf (register-pairs pool) nil))

;;; cleanup-object

(defun cleanup-object (object &optional (pool *pool*))
  (let ((pair (iter (for cleanup-pair in (register-pairs pool))
                    (finding cleanup-pair such-that (eq object (car cleanup-pair))))))
    (if (and pair (car pair) (cdr pair))
        (funcall (cdr pair) (car pair)))
    (delete pair (register-pairs pool))))

;;; with-garbage-pool

(defmacro with-garbage-pool ((&optional (var '*pool*)) &body body)
  `(let ((,var (make-instance 'pool)))
     (unwind-protect
          (progn ,@body)
       (cleanup-pool ,var))))

;;; object-register

(defgeneric object-register (object &optional pool))

;;; defcleanup

(defmacro defcleanup (class cleanup-fun)
  `(defmethod garbage-pools:object-register ((object ,class) &optional (pool garbage-pools::*pool*))
     (garbage-pools:cleanup-register object ,cleanup-fun pool)))

(defcleanup pool #'cleanup-pool)

(defcleanup stream #'close)
     

  