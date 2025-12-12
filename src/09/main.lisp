(defpackage :day09
  (:use :cl :arrows :lparallel)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day09)

(defun parse (content)
  (labels ((parse-lines (line)
             (-<> (str:split "," line)
                  (remove-if #'str:empty? <>)
                  (map 'list #'parse-integer <>))))
    (-<> (str:lines (str:trim content))
         (map 'vector #'parse-lines <>))))

(defun part01 (content)
  (let* ((tiles (parse content)))
    (-<> (loop
           for a from 0 below (length tiles)
           collect (loop
                     for b from (1+ a) below (length tiles)
                     collect (let ((a-tile (aref tiles a))
                                   (b-tile (aref tiles b)))
                               (* (1+ (abs (- (first a-tile) (first b-tile))))
                                  (1+ (abs (- (second a-tile) (second b-tile))))))))
         (apply #'append <>)
         (apply #'max <>))))

(defun border (tiles)
  (let* ((points (make-hash-table :test #'equal)))
    (loop for i from 0 below (length tiles) do
      (let* ((l (aref tiles i))
             (r (aref tiles (mod (1+ i) (length tiles)))))
        (loop
          for x
            from (min (first l) (first r))
              to (max (first l) (first r))
          do (loop
               for y
                 from (min (second l) (second r))
                   to (max (second l) (second r))
               do (incf (gethash (list x y) points 0))))))
    points))

(defun contains-border (l r keys)
  (loop named loop-1
         for k in keys
          do (when (and
                    (and
                     (< (min (first l) (first r)) (first k))
                     (< (first k) (max (first l) (first r))))
                    (and
                     (< (min (second l) (second r)) (second k))
                     (< (second k) (max (second l) (second r)))))
               (return-from loop-1 t))))

(setf lparallel:*kernel*
      (lparallel:make-kernel 8 :name "aoc-kernel"))

(defun part02 (content)
  (let* ((tiles (parse content))
         (points (border tiles))
         (keys (alexandria:hash-table-keys points)))
    (labels ((job (a-b)
               (let* ((a (first a-b))
                      (b (second a-b))
                      (a-tile (aref tiles a))
                      (b-tile (aref tiles b)))
                 (if (contains-border a-tile b-tile keys)
                     0
                     (* (1+ (abs (- (first a-tile) (first b-tile))))
                        (1+ (abs (- (second a-tile) (second b-tile)))))))))
      (-<> (loop
             for a from 0 below (length tiles)
             collect (loop
                       for b from (1+ a) below (length tiles)
                       collect (list a b)))
           (apply #'append <>)
           (pmap 'list #'job :parts 32 <>)
           (apply #'max <>)))))

(defun main ()
  (let ((content (utils:read-input "09")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
