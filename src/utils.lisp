(in-package :openexr.utils)

(defun read-null-terminated-array (type stream)
  "Reads an array of TYPE terminated with a null byte (#x0). Returns the array and number of bytes read"
  (let ((type-array (make-array 0 :adjustable t :fill-pointer 0))
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
