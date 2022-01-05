(in-package :openexr.attributes)


(defbinary box2i (:export t :byte-order :little-endian)
           (xmin 0 :type (signed-byte 32))
           (ymin 0 :type (signed-byte 32))
           (xmax 0 :type (signed-byte 32))
           (ymax 0 :type (signed-byte 32)))

(defbinary box2f (:export t :byte-order :little-endian)
           (xmin 0.0 :type single-float)
           (ymin 0.0 :type single-float)
           (xmax 0.0 :type single-float)
           (ymax 0.0 :type single-float))

(defbinary v2i (:export t :byte-order :little-endian)
           (x 0 :type (signed-byte 32))
           (y 0 :type (signed-byte 32)))

(defbinary v2f (:export t :byte-order :little-endian)
           (x 0.0 :type single-float)
           (y 0.0 :type single-float))

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

(define-enum compression-type 1 (:byte-order :little-endian)
             :no-compression
             :rle-compression
             :zips-compression
             :zip-compression
             :piz-compression
             :pxr24-compression
             :b44-compression
             :b44a-compression)

(define-enum line-order 1 (:byte-order :little-endian)
             :increasing-y
             :decreasing-y
             :random-y)


(defbinary openexr-header-attribute (:export t :byte-order :little-endian)
           (name "" :type (terminated-string 1 :terminator 0))
           (attribute-type "" :type (terminated-string 1 :terminator 0))
           (size 0 :type (signed-byte 32))
           (value 0 :type (eval
                           (alexandria:switch (attribute-type :test #'equal)
                             ("int" '(signed-byte 32))
                             ("float" 'single-float)
                             ("double" 'double-float)
                             ("box2i" 'box2i)
                             ("box2f" 'box2f)
                             ("v2i" 'v2i)
                             ("v2f" 'v2f)
                             ("chlist" '(custom
                                         :reader (lambda (stream)
                                                   (multiple-value-bind (stream read-size)
                                                       (read-null-terminated-array 'channel-layout stream)
                                                     (setf size read-size)
                                                     (values stream read-size)))
                                         :writer (lambda (obj stream)
                                                   (write-null-terminated-array obj 'channel-layout stream))))
                             ("compression" 'compression-type)
                             ("lineOrder" 'line-order)
                                        ; Fall back to just grabbing the data as a byte array
                             (otherwise `(simple-array (unsigned-byte 8) (,size)))))))

(defun find-attribute-with-name (name attributes)
  "Search ATTRIBUTES for one with provided NAME. Returns nil if no match"
  (loop for attr across attributes do
        (when (string= (openexr-header-attribute-name attr) name)
          (return attr)))
  nil)

(defun find-data-window (attributes)
  "Searches ATTRIBUTES for the data window"
  (find-attribute-with-name "dataWindow" attributes))

(defun get-number-of-lines (attributes)
  "Finds the 'dataWindow' attribute and returns the number of lines"
  (let ((result (find-data-window attributes)))
    (when (null result)
      (error "OpenEXR file does not contain a data window"))
    (- (box2i-ymax result) (box2i-ymin result))))
