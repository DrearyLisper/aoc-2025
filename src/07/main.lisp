(defpackage :day07
  (:use :cl :arrows)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day07)

(defstruct point x y)

(defun point-test (a b)
  (and (= (point-x a) (point-x b))
       (= (point-y a) (point-y b))))
(defun point-hash (a)
  (sxhash (list (point-x a) (point-y a))))

(defstruct state m start-position)

(defun parse (content)
  (let*  ((m (str:lines (str:trim content)))
          (start-position (position #\S (first m))))
    (make-state :m (coerce m 'vector) :start-position start-position)))

(defun trace-splitters (x y m cache)
  (match (list x (aref (aref m x) y) (gethash (make-point :x x :y y) cache))
    ((guard (list _ _ v) v) 0)
    ((guard (list x _ _) (equal (length m) (1+ x))) 0)
    ((list _ #\. _) (progn
                      (setf (gethash (make-point :x x :y y) cache) 0)
                      (trace-splitters (1+ x) y m cache)))
    ((list _ #\^ _)
     (let* ((l (trace-splitters x (1- y) m cache))
            (r (trace-splitters x (1+ y) m cache)))
       (setf (gethash (make-point :x x :y (1- y)) cache) 0)
       (setf (gethash (make-point :x x :y (1+ y)) cache) 0)
       (+ 1 l r)))))

(defun part01 (content)
  (let* ((state (parse content)))
    (trace-splitters
     1
     (state-start-position state)
     (state-m state)
     (make-hash-table :test #'point-test :hash-function #'point-hash))))

(defun trace-beam (x y m cache)
  (match (list x (aref (aref m x) y) (gethash (make-point :x x :y y) cache))
    ((guard (list _ _ v) v) v)
    ((guard (list x _ _) (equal (length m) (1+ x))) 1)
    ((list _ #\. _) (trace-beam (1+ x) y m cache))
    ((list _ #\^ _)
     (let* ((l (trace-beam x (1- y) m cache))
            (r (trace-beam x (1+ y) m cache)))
       (setf (gethash (make-point :x x :y (1- y)) cache) l)
       (setf (gethash (make-point :x x :y (1+ y)) cache) r)
       (+ l r)))))

(defun part02 (content)
  (let* ((state (parse content)))
    (trace-beam
     1
     (state-start-position state)
     (state-m state)
     (make-hash-table :test #'point-test :hash-function #'point-hash))))

(defun main ()
  (let ((content (utils:read-input "07")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
