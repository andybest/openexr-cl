(in-package :openexr)


(defbinary openexr-file (:export t :byte-order :little-endian)
  (magic 20000630 :type (magic :actual-type (signed-byte 32) :value 20000630))

                                        ; This bitfield represents the "version" field in the OpenEXR format
  ((version single-tile long-name non-image multipart unused) nil :type (bit-field :raw-type (unsigned-byte 32)
                                                                                   :member-types
                                                                                   ((unsigned-byte 8)
                                                                                    (unsigned-byte 1)
                                                                                    (unsigned-byte 1)
                                                                                    (unsigned-byte 1)
                                                                                    (unsigned-byte 1)
                                                                                    (unsigned-byte 20)))
   (header nil :type (custom :reader (lambda (stream)
                                       (read-null-terminated-array 'openexr-header-attribute stream))
                             :writer (lambda (obj stream)
                                       (write-null-terminated-array obj 'openexr-header-attribute stream))))
   (chunk-offset-table 0 :type (unsigned-byte 32))))
