(defpackage openexr/tests/utils
  (:use :cl
        :lisp-binary
        :openexr.utils
        :rove))
(in-package :openexr/tests/utils)


(defun get-test-file-path (filename)
  (merge-pathnames (merge-pathnames filename #P"test-input/")
                   (asdf:system-source-directory :openexr/tests)))


;; A simple binary containing only a 32 bit integer
(defbinary int-test-binary (:byte-order :little-endian)
  (item 0 :type (unsigned-byte 32)))


(deftest test-read-null-terminated-array
  (testing "expect array of non-zero ints to be read correctly"
    (with-open-binary-file (in
                            (get-test-file-path #P"null-terminated-int-array.bin")
                            :direction :input)
      (multiple-value-bind (result count) (read-null-terminated-array 'int-test-binary in)
        (ok (= (length result) 2))
        (ok (= (int-test-binary-item (aref result 0)) #x12345678))
        (ok (= (int-test-binary-item (aref result 1)) #x89ABCDEF))
        (ok (= count 9))))))

(rove:run-suite :openexr/tests/utils)
