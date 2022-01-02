(defpackage openexr-cl/tests/main
  (:use :cl
        :openexr-cl
        :rove))
(in-package :openexr-cl/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :openexr-cl)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
