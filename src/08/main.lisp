(defpackage :day08
  (:use :cl :arrows)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day08)

(defun distance (a b)
  (sqrt (apply #'+ (loop for i across a
                         for j across b
                         collect (* (- i j) (- i j))))))

(defun pairs (points)
  (apply #'append
         (loop
           for i from 0 below (length points)
           collect
           (loop
             for j from (1+ i) below (length points)
             collect
             (list
              (distance (aref points i) (aref points j))
              i j)))))

(defun parse (content)
  (labels ((parse-line (line)
             (-<> (str:split "," (str:trim line))
                  (map 'vector #'parse-integer <>))))
    (-<> (str:lines (str:trim content))
         (map 'vector #'parse-line <>))))

(defun find-parent (i parents)
  (let ((parent (aref parents i)))
    (if (equal parent i) i (find-parent parent parents))))

(defun connect (i j parents sizes)
  (let* ((i-parent (find-parent i parents))
         (j-parent (find-parent j parents))
         (i-size (aref sizes i-parent))
         (j-size (aref sizes j-parent)))
    (unless (equal i-parent j-parent)
      (if (< i-size j-size)
          (progn
            (setf (aref parents i-parent) j-parent)
            (setf (aref sizes j-parent) (+ i-size j-size)))
          (progn
            (setf (aref parents j-parent) i-parent)
            (setf (aref sizes i-parent) (+ i-size j-size))))
      (if (equal (+ i-size j-size) (length parents))
          (list i j)))))

(defun part01 (content)
  (let* ((points (parse content))
         (items (sort (pairs points) #'< :key #'first))
         (parents (coerce (loop for i from 0 below (length points) collect i) 'vector))
         (sizes (make-array (length points) :initial-element 1))
         (ht (make-hash-table)))
    (loop for item in (subseq items 0 1000) do
      (let ((a (second item))
            (b (third item)))
        (connect a b parents sizes)))
    (loop for i from 0 below (length points)
          do
             (incf (gethash (find-parent i parents) ht 0)))
    (-<> (sort (alexandria:hash-table-values ht) #'>)
         (subseq <> 0 3)
         (apply #'* <>))))

(defun part02 (content)
  (let* ((points (parse content))
         (items (sort (pairs points) #'< :key #'first))
         (parents (coerce (loop for i from 0 below (length points) collect i) 'vector))
         (sizes (make-array (length points) :initial-element 1))
         (a-b
           (loop named loop-1
                 for item in items do
                   (let* ((a (second item))
                          (b (third item))
                          (a-b (connect a b parents sizes)))
                     (when a-b (return-from loop-1 a-b))))))
    (*
     (aref (aref points (first a-b)) 0)
     (aref (aref points (second a-b)) 0))))

(defun main ()
  (let ((content (utils:read-input "08")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
