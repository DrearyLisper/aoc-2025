(in-package :cl-user)
(defpackage :day07-test
  (:use :cl :fiveam :day07))
(in-package :day07-test)

(def-suite* day07-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "07")))
        (is (= 1550 (day07::part01 content)))))

(test part02
      (let ((content (utils:read-input "07")))
        (is (= 9897897326778 (day07::part02 content)))))
