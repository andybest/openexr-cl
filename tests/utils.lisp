(defpackage openexr/tests/utils
  (:use :cl
        :openexr.utils
        :rove))
(in-package :openexr/tests/utils)

(deftest test-read-null-terminated-array
  (testing "expect array of non-zero ints to be read correctly"
           (let ((input-bytes)))))
