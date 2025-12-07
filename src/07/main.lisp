(defpackage :day07
  (:use :cl :arrows :alexandria)
  (:import-from :trivia #:match #:guard)
  (:export #:main))

(in-package :day07)



(defstruct point x y)

(defun point-test (a b)
  (and (= (point-x a) (point-x b))
       (= (point-y a) (point-y b))))
(defun point-hash (a)
  (sxhash (list (point-x a) (point-y a))))

(defstruct state m current-points history-points)

(defun add-point (history-points x y)
  (let* ((new-point (make-point :x x :y y)))
    (if (find new-point history-points :test #'point-test )
        '()
        (list new-point))))


(defun parse (content)
  (let*  ((m (str:lines (str:trim content)))
          (start-position (position #\S (first m))))
    (make-state :m (coerce m 'vector)
                :current-points (list (make-point :x 0 :y start-position))
                :history-points (list (make-point :x 0 :y start-position)))))

(defun trace-state (state r i)
  (let* ((m (state-m state))
         (current-points (state-current-points state))
         (history-points (state-history-points state))
         (first-point (first current-points)))

    (match first-point
      (nil r)
      ((point :x x :y y)
       (match (1+ x)
         ((guard new-x (= (length m) new-x)) (trace-state (make-state :m m
                                                                      :current-points (rest current-points)
                                                                      :history-points history-points) r i))

         (new-x
          (match (aref (aref m new-x) y)
            (#\. (trace-state (make-state :m m
                                          :current-points (append (add-point history-points new-x y)
                                                                  (rest current-points))
                                          :history-points (append (add-point history-points new-x y)
                                                                  history-points))
                              r i))

            (#\^ (trace-state (make-state :m m
                                          :current-points (append (add-point history-points new-x (1- y))
                                                                  (add-point history-points new-x (1+ y))
                                                                  (rest current-points))
                                          :history-points (append (add-point history-points new-x (1- y))
                                                                  (add-point history-points new-x (1+ y))
                                                                  history-points))
                              (cons (make-point :x new-x :y y) r))))))))))

(defun part01 (content)
  (let* ((state (parse content))
         (points (make-hash-table :test #'point-test :hash-function #'point-hash)))
    (-<> (trace-state state nil 1)
         (loop for point in <> do
           (setf (gethash point points) 1)))
    (length (alexandria:hash-table-keys points))))

(defun part02 (content)
  (length content))

(defun main ()
  (let ((content (utils:read-test "07")))
    (format t "~S~%" (part01 content))
    (format t "~S~%" (part02 content))))
