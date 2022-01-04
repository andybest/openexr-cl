(defpackage openexr/tests/utils
  (:use :cl
        :openexr.utils
        :rove))
(in-package :openexr/tests/utils)

(defvar *stream* nil)

(defun get-test-file-path (filename)
  (merge-pathnames (merge-pathnames filename #P"test-input/")
                   (asdf:system-source-directory :openexr/tests)))

(defmacro with-read-stream (contents &body body)
  `(with-input-from-sequence (*stream* ,contents)
     ,@body))

(defconstant +int-array+
  #(#x78 #x56 #x34 #x12
    #xEF #xCD #xAB #x89
    #x00))


(defbinary test-binary (:byte-order :litle-endian)
  (item 0 :type (unsigned-byte 32)))

(deftest test-read-null-terminated-array
  (testing "expect array of non-zero ints to be read correctly"
    (with-open-file (in
                     (get-test-file-path #P"null-terminated-int-array.bin")
                     :direction :input
                     :element-type '(unsigned-byte 8))
      (let ((result (read-null-terminated-array 'item in)))
        (ok (= (length result) 2))
        (ok (= (aref result 1) #x12345678))
        (ok (= (aref result 1) #x89ABCDEF)))))

  (rove:run-suite :openexr/tests/utils))
