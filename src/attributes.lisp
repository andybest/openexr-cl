(in-package :openexr.attributes)


(defbinary box2i (:export t :byte-order :little-endian)
           (xmin 0 :type (signed-byte 32))
           (ymin 0 :type (signed-byte 32))
           (xmax 0 :type (signed-byte 32))
           (ymax 0 :type (signed-byte 32)))

(defbinary box2f (:export t :byte-order :little-endian)
           (xmin 0 :type single-float)
           (ymin 0 :type single-float)
           (xmax 0 :type single-float)
           (ymax 0 :type single-float))

(define-enum channel-pixel-type 4 (:byte-order :little-endian)
    :uint
    :half
    :float)

(defbinary channel-layout (:export t :byte-order :little-endian)
           (name "" :type (terminated-string 1 :terminator 0))
           (pixel-type :uint :type channel-pixel-type)
           (plinear 0 :type (unsigned-byte 8))
           (reserved 0 :type (unsigned-byte 24))
           (xsampling 0 :type (signed-byte 32))
           (ysampling 0 :type (signed-byte 32)))


(defun read-null-terminated-array (type stream)
  "Reads an array of TYPE terminated with a null byte (#x0). Returns the array and number of bytes read"
  (let ((type-array (make-array 0))
        (bytes-read 0))
    (loop
      (let ((start-position (file-position stream)))
        (if (= (read-byte stream) #x0)
                                        ; If it's a null byte, return
            (return (values type-array (+ bytes-read 1)))
                                        ; Otherwise, rewind the stream and read TYPE from it
            (progn
              (file-position stream start-position)
              (let ((result (read-binary type stream)))
                (setf bytes-read (+ bytes-read (- (file-position stream) start-position)))
                (vector-push-extend result type-array))))))))


;; chlist compression box2i lineOrder float v2f


;; (defbinary openexr-header-attribute (:export t :byte-order :little-endian)
;;   (name "" :type (terminated-string 1 :terminator 0))
;;   (attribute-type "" :type (terminated-string 1 :terminator 0))
;;   (size 0 :type (signed-byte 32))
;;   (value 0 :type (eval
;;                   (case attribute-type
;;                     ("box2i" 'box2i)
;;                     ("box2f" 'box2f)
;;                     ("chlist" '())))))
