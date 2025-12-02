(in-package :cl-user)
(defpackage :day01-test
  (:use :cl :fiveam :day01))
(in-package :day01-test)

(def-suite* day01-test :in cl-user::aoc-2025/test)

(test part01
  (let ((content (utils:read-input "01")))
    (is (= 1120 (day01::part01 content)))))

(test part02
  (let ((content (utils:read-input "01")))
    (is (= 6554 (day01::part02 content)))))
