(defpackage :day04
  (:use :cl :arrows)
  (:import-from :trivia #:match)
  (:export #:main))

(in-package :day04)

(defun parse (content)
  (labels ((parse-line (line)
             (-<> (str:split "" line)
                  (remove-if #'str:empty? <>)
                  (apply #'vector <>))))
    (-<> (str:lines content)
         (remove-if #'str:empty? <>)
         (map 'vector #'parse-line <>))))

(defun access (m x y)
  (block nil
    (when (or (< x 0) (>= x (length m)))
      (return 0))
    (when (or (< y 0) (>= y (length (aref m 0))))
      (return 0))
    (if (equal "@" (aref (aref m x) y)) 1 0)))

(defun convolve (m x y)
  (-<> (loop
         for dx from -1 to 1
         collect
         (loop
           for dy from -1 to 1
           when (not (equal 0 (+ (abs dx) (abs dy))))
             collect (access m (+ x dx) (+ y dy))))
       (apply #'append <>)
       (apply #'+ <>)))

(defun part01 (content)
  (let ((m (parse content)))
    (-<> (loop
           for x from 0 to (1- (length m))
           collect
           (loop
             for y from 0 to (1- (length (aref m x)))
             when (equal "@" (aref (aref m x) y))
               collect
               (convolve m x y)))
         (apply #'append <>)
         (remove-if-not (lambda (x) (< x 4)) <>)
         (length <>))))

(defun remove-rolls (m)
  (let ((removed 0))
    (loop for x from 0 to (1- (length m)) do
      (loop for y from 0 to (1- (length (aref m x)))
            when (equal "@" (aref (aref m x) y))
              do
                 (let ((s (convolve m x y)))
                   (when (< s 4)
                     (incf removed)
                     (setf (aref (aref m x) y) ".")))))
    (if (> removed 0)
        (+ removed (remove-rolls m))
        0)))

(defun part02 (content)
  (let ((m (parse content)))
    (remove-rolls m)))

(defun main ()
  (let ((content (utils:read-input "04")))
    (format t "~A~%" (part01 content))
    (format t "~A~%" (part02 content))))
