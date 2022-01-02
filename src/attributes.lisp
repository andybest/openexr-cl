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


(defbinary openexr-header-attribute (:export t :byte-order :little-endian)
  (name "" :type (terminated-string 1 :terminator 0))
  (attribute-type "" :type (terminated-string 1 :terminator 0))
  (size 0 :type (signed-byte 32))
  (value 0 :type (eval
                  (case attribute-type
                    ("box2i" 'box2i)
                    ("box2f" 'box2f)
                    ("chlist" '())))))
