(defpackage :day10
  (:use :cl :arrows)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day10)

(defun part01 (content)
  (length content))

(defun part02 (content)
  (length content))

(defun main ()
  (let ((content (utils:read-input "09")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
