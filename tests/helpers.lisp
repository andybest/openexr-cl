(defpackage openexr/tests/helpers
  (:use :cl)
  (:export :get-test-file-path
           :files-match-p))
(in-package :openexr/tests/helpers)


(defun get-test-file-path (filename)
  "Get the full path of the test file with FILENAME"
  (merge-pathnames (merge-pathnames filename #P"test-input/")
                   (asdf:system-source-directory :openexr/tests)))

(defun files-match-p (path1 path2)
  "If the contents of the files at PATH1 and PATH2 are the same, returns t"
  (let ((file1 (read-file path1))
        (file2 (read-file path2)))
       (equalp file1 file2)))
