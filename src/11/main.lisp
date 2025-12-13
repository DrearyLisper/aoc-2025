(defpackage :day11
  (:use :cl :arrows)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day11)

(defun parse (content)
  (let ((ht (make-hash-table :test #'equal)))
    (labels ((parse-line (line)
               (let* ((parts (str:split " " line))
                      (from (subseq (first parts) 0 3))
                      (to (rest parts)))
                 (setf (gethash from ht) to))))
      (loop for l in (str:lines (str:trim content))
            do (parse-line l)))
    ht))

(defun count-paths (graph from to cache)
  (let ((c (gethash (list from to) cache)))
    (if c
        c
        (let ((answer (if (equal from to)
                           1
                           (-<> (gethash from graph)
                                (map 'list (lambda (x) (count-paths graph x to cache)) <>)
                                (apply #'+ <>)))))
          (setf (gethash (list from to) cache) answer)
          answer))))

(defun part01 (content)
  (let ((graph (parse content)))
    (count-paths graph "you" "out" (make-hash-table :test #'equal))))

(defun part02 (content)
  (let ((graph (parse content)))
    (* (count-paths graph "svr" "fft" (make-hash-table :test #'equal))
       (count-paths graph "fft" "dac" (make-hash-table :test #'equal))
       (count-paths graph "dac" "out" (make-hash-table :test #'equal)))))

(defun main ()
  (let ((content (utils:read-input "11")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
