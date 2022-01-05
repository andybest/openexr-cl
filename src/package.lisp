(defpackage openexr.utils
  (:use :common-lisp :lisp-binary :lisp-binary-utils)
  (:export :read-null-terminated-array
           :write-null-terminated-array))

(defpackage openexr.attributes
  (:use :common-lisp :lisp-binary :lisp-binary-utils :openexr.utils)
  (:export :openexr-header-attribute))

(defpackage openexr
  (:use :common-lisp :lisp-binary :lisp-binary-utils :openexr.attributes))
