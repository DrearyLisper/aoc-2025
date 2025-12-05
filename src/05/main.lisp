(defpackage :day05
  (:use :cl :arrows)
  (:import-from :trivia #:match)
  (:export #:main))

(in-package :day05)

(declaim (optimize (debug 3)))

(defun part01 (content)
  (labels
      ((parse (content)
         (let* ((parts (str:split (coerce '(#\newline #\newline) 'string) content))
                (intervals-str (str:trim (first parts)))
                (ingredients-str (str:trim (second parts)))
                (intervals (-<> intervals-str
                                (str:lines <>)
                                (map 'list (lambda (s) (map 'list #'parse-integer (str:split "-" (str:trim s)))) <>)))
                (ingredients (-<> ingredients-str
                                  (str:lines <>)
                                  (map 'list #'parse-integer <>))))
           (list intervals ingredients)))
       (contained-in? (intervals i)
         (match (first intervals)
           (nil nil)
           ((list l r) (or (and (>= i l) (<= i r)) (contained-in? (rest intervals) i))))))
    (let* ((parts (parse content))
           (intervals (first parts))
           (ingredients (second parts)))
      (-<> (map 'list (lambda (i) (contained-in? intervals i)) ingredients)
           (remove-if-not #'identity <>)
           (length <>)))))

(defun part02 (content)
  (labels
      ((lists< (a b)
         (match (list (< (first a) (first b)) (equal (first a) (first b)))
           ((list t _) t)
           ((list nil nil) nil)
           ((list nil t) (lists< (rest a) (rest b)))))

       (parse (content)
         (let* ((parts (str:split (coerce '(#\newline #\newline) 'string) content))
                (intervals-str (str:trim (first parts)))
                (intervals (-<> intervals-str
                                (str:lines <>)
                                (map 'list (lambda (s) (map 'list #'parse-integer (str:split "-" (str:trim s)))) <>))))
           (-<> intervals
                (loop
                  for i in <>
                  for index from 0
                  collect
                  (list (list (first i) 0 index) (list (second i) 1 index)))
                (apply #'append <>)
                (sort <> #'lists<))))

       (iterate (points d)
         (match (list d (first points))
           ((list _ nil) nil)
           ((list 0 (list l 0 _)) (cons l (iterate (rest points) (1+ d))))
           ((list d (list _ 0 _)) (iterate (rest points) (1+ d)))
           ((list 1 (list r 1 _)) (cons r (iterate (rest points) (1- d))))
           ((list d (list _ 1 _)) (iterate (rest points) (1- d)))))

       (compute (i)
         (match (list (first i) (second i))
           ((list nil _) 0)
           ((list l r) (+ 1 (- r l) (compute (rest (rest i))))))))

    (-<> (iterate (parse content) 0)
         (compute <>))))

(defun main ()
  (let ((content (utils:read-input "05")))
    (format t "~A~%" (part01 content))
    (format t "~A~%" (part02 content))))
