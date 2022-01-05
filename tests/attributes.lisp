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
        (ok (= (length attributes) 8))))))

(defun make-test-attributes ()
  (make-attribute-array :attributes
                        (vector
                         (make-openexr-header-attribute :name "channels"
                                                        :attribute-type "chlist"
                                                        :size 37
                                                        :value (vector
                                                                (make-channel-layout :name "G" :pixel-type :half :xsampling 1 :ysampling 1)
                                                                (make-channel-layout :name "Z" :pixel-type :float :xsampling 1 :ysampling 1)))
                         (make-openexr-header-attribute :name "compression"
                                                        :attribute-type "compression"
                                                        :size 1
                                                        :value :no-compression)
                         (make-openexr-header-attribute :name "dataWindow"
                                                        :attribute-type "box2i"
                                                        :size 16
                                                        :value (make-box2i :xmax 3 :ymax 2))
                         (make-openexr-header-attribute :name "displayWindow"
                                                        :attribute-type "box2i"
                                                        :size 16
                                                        :value (make-box2i :xmax 3 :ymax 2))
                         (make-openexr-header-attribute :name "lineOrder"
                                                        :attribute-type "lineOrder"
                                                        :size 1
                                                        :value :increasing-y)
                         (make-openexr-header-attribute :name "pixelAspectRatio"
                                                        :attribute-type "float"
                                                        :size 4
                                                        :value 1.0)
                         (make-openexr-header-attribute :name "screenWindowCenter"
                                                        :attribute-type "v2f"
                                                        :size 8
                                                        :value (make-v2f))
                         (make-openexr-header-attribute :name "screenWindowWidth"
                                                        :attribute-type "float"
                                                        :size 4
                                                        :value 1.0))))


(deftest test-write-header-attribute-array ()
  (testing "expect array of header attributes to be written correctly"
    (let ((output-path #p"/tmp/openexr-test.bin"))
      (with-open-binary-file (out output-path :direction :output
                                              :if-exists :overwrite
                                              :if-does-not-exist :create)
        (write-binary (make-test-attributes) out))
      (ok (files-match-p output-path
                         (get-test-file-path #P"attribute-array.bin"))))))



(rove:run-suite :openexr/tests/attributes)
