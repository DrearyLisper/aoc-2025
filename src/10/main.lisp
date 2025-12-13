(defpackage :day10
  (:use :cl :arrows :lparallel)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day10)

(defun parse (content)
  (labels ((parse-line (line)
             (str:split " " line))
           (parse-answer (parts)
             (let* ((part (first parts)))
               (-<> (subseq part 1 (1- (length part)))
                    (map 'vector (lambda (x) (if (equal #\. x) 0 1)) <>))))
           (parse-button (part)
             (-<> (subseq part 1 (1- (length part)))
                  (str:split "," <>)
                  (map 'vector #'parse-integer <>)))
           (parse-voltage (parts)
             (let* ((part (first (last parts))))
               (-<> (subseq part 1 (1- (length part)))
                    (str:split "," <>)
                    (map 'vector #'parse-integer <>))))
           (parse-buttons (parts)
             (let* ((part (butlast (rest parts))))
               (map 'list #'parse-button part))))
    (let* ((parts (-<> (str:lines (str:trim content))
                       (map 'list #'parse-line <>))))
      (map 'list #'list
           (map 'list #'parse-answer parts)
           (map 'list #'parse-buttons parts)
           (map 'list #'parse-voltage parts)))))

(defun apply-button (a button)
  (let ((a-copy (copy-seq a)))
    (loop for i across button do
      (setf (aref a-copy i)
            (mod (1+ (aref a-copy i)) 2)))
    a-copy))

(defun find-buttons (a buttons total)
  (if (equal 0 (reduce #'+ a))
      total
      (if (not buttons)
          100
          (min (find-buttons (apply-button a (first buttons)) (rest buttons) (1+ total))
               (find-buttons a (rest buttons) total)))))

(defun part01 (content)
  (let* ((problems (parse content)))
    (-<> problems
         (map 'list (lambda (x) (find-buttons (first x) (second x) 0)) <>)
         (apply #'+ <>))))

(defun apply-button-2 (a button)
  (let ((a-copy (copy-seq a)))
    (loop for i across button do
      (setf (aref a-copy i)
            (- (aref a-copy i) 1)))
    a-copy))

(defun divide-by-2 (a)
  (let ((a-copy (copy-seq a)))
    (map 'vector (lambda (x) (/ x 2)) a-copy)))


(defun find-buttons-2 (a buttons all-buttons total)
  (if (equal 0 (reduce #'+ (map 'vector #'abs a)))
      total
      (if (find-if (lambda (x) (< x 0)) a)
          1000000
          (min (if (not (find-if (lambda (x) (equal (mod x 2) 1)) a))
                   (+ total (* 2 (find-buttons-2 (divide-by-2 a) all-buttons all-buttons 0)))
                   1000000)
               (if (not buttons)
                   1000000
                   (min (find-buttons-2 a (rest buttons) all-buttons total)
                        (find-buttons-2 (apply-button-2 a (first buttons)) (rest buttons) all-buttons (1+ total))))))))

(setf lparallel:*kernel*
      (lparallel:make-kernel 16 :name "aoc-kernel"))

(defun part02 (content)
  (let* ((problems (parse content)))
    (-<> problems
         (pmap 'list (lambda (x) (find-buttons-2 (first (last x)) (second x) (second x) 0)) <>)
         (apply #'+ <>))))

(defun main ()
  (let ((content (utils:read-input "10")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
