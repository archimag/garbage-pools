;; garbage-pools.asd

(defsystem :garbage-pools
  :depends-on (#:iterate)
  :components ((:module :src
                        :components
                        ((:file "package")
                         (:file "garbage-pools" :depends-on ("package"))))))
  