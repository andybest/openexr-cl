(defpackage openexr/tests/utils
  (:use :cl
        :openexr/tests/helpers
        :lisp-binary
        :openexr.utils
        :rove))
(in-package :openexr/tests/utils)


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

(deftest test-write-null-terminated-array
  (testing "expect array of non-zero ints to be written correctly"
    (let ((output-path #P"/tmp/openexr-test.bin"))
      (with-open-binary-file (out output-path :direction :output
                                              :if-exists :overwrite
                                              :if-does-not-exist :create)
        (let ((count (write-null-terminated-array (vector (make-int-test-binary :item #x12345678)
                                                          (make-int-test-binary :item #x89ABCDEF))
                                                  'int-test-binary
                                                  out)))
          (ok (= count 9))))
      (ok (files-match-p output-path
                         (get-test-file-path #P"null-terminated-int-array.bin"))))))

;; (rove:run-suite :openexr/tests/utils)
