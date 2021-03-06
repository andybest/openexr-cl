(defsystem "openexr"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("lisp-binary")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "utils")
                 (:file "attributes")
                 (:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "openexr/tests"))))

(defsystem "openexr/tests"
  :author ""
  :license ""
  :depends-on (:openexr
               :flexi-streams
               :rove)
  :components ((:module "tests"
                :components
                ((:file "helpers")
                 (:file "main")
                 (:file "utils")
                 (:file "attributes"))))
  :description "Test system for openexr"
  :perform (test-op (op c) (symbol-call :rove :run c)))
