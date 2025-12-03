(defpackage :day03
  (:use :cl :arrows)
  (:import-from :trivia #:match)
  (:export #:main))

(in-package :day03)

(defun parse (line)
  (-<> (remove-if #'str:empty? (str:split "" line))
       (map 'list #'parse-integer <>)))

(defun first-max (lst from to)
  (let* ((subl (subseq lst from (1+ to)))
         (m (apply #'max subl)))
    (+ from (position m subl))))

(defun find-largest (n)
  (lambda (lst)
    (let* ((l 0)
           (r (- (length lst) n)))
      (-<> (loop for i from 0 to (1- n) collect
                                        (let ((p (first-max lst l r)))
                                          (setf l (+ 1 p))
                                          (setf r (+ 1 r))
                                          (nth p lst)))
           (map 'list #'write-to-string <>)
           (str:join "" <>)
           (parse-integer <>)))))


(defun part01 (content)
  (-<> (str:lines (str:trim content))
       (map 'list #'parse <>)
       (map 'list (find-largest 2) <>)
       (apply #'+ <>)))

(defun part02 (content)
  (-<> (str:lines (str:trim content))
       (map 'list #'parse <>)
       (map 'list (find-largest 12) <>)
       (apply #'+ <>)))

(defun main ()
  (let ((content (utils:read-input "03")))
    (format t "~A~%" (part01 content))
    (format t "~A~%" (part02 content))))
