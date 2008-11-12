;; garbage-pools-test.asd

(defsystem :garbage-pools-test
  :depends-on (#:garbage-pools #:lift)
  :components ((:module :test
                        :components
                        ((:file "test")))))