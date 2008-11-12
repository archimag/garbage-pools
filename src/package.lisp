;; package.lisp

(defpackage :garbage-pools
  (:use #:cl #:iter)
  (:nicknames #:gp)
  (:export #:pool
           #:with-garbage-pool
           #:cleanup-register
           #:cleanup-pool
           #:cleanup-object
           #:object-register
           #:defcleanup))