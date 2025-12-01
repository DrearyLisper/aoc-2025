(defpackage :utils
  (:use :cl :alexandria)
  (:export #:read-input #:read-test))

(in-package :utils)

(defun read-input (day)
  (let* ((filename (format nil "src/~A/input.txt" day)))
    (alexandria:read-file-into-string filename)))

(defun read-test (day)
  (let* ((filename (format nil "src/~A/test.txt" day)))
    (alexandria:read-file-into-string filename)))
