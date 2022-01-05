(defpackage :openexr/tests/attributes
  (:use :common-lisp
        :openexr/tests/helpers
        :lisp-binary
        :openexr.attributes
        :openexr.utils
        :rove))
(in-package :openexr/tests/attributes)


(defbinary attribute-array (:export t :byte-order :little-endian)
           (attributes nil :type (custom
                                  :reader (lambda (stream)
                                            (read-null-terminated-array 'openexr-header-attribute stream))
                                  :writer (lambda (obj stream)
                                            (write-null-terminated-array obj 'openexr-header-attribute stream)))))


(deftest test-read-attribute-array
  (testing "expect array of header attributes to be read correctly"
    (with-open-binary-file (in
                            (get-test-file-path #P"attribute-array.bin")
                            :direction :input)
      (let* ((attributes-binary (read-binary 'attribute-array in))
             (attributes (attribute-array-attributes attributes-binary)))
        (ok (= (length attributes) 8))
        (print attributes)))))

;; (rove:run-suite :openexr/tests/attributes)
