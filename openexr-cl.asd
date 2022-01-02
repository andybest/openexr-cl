(defsystem "openexr-cl"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("lisp-binary")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "openexr-cl/tests"))))

(defsystem "openexr-cl/tests"
  :author ""
  :license ""
  :depends-on ("openexr-cl"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for openexr-cl"
  :perform (test-op (op c) (symbol-call :rove :run c)))
