(in-package :cl-user)
(defpackage :day09-test
  (:use :cl :fiveam :day09))
(in-package :day09-test)

(def-suite* day09-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "09")))
        (is (= 4738108384 (day09::part01 content)))))

(test part02
      (let ((content (utils:read-input "09")))
        (is (= 1513792010 (day09::part02 content)))))
