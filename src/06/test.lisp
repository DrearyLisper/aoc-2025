(in-package :cl-user)
(defpackage :day06-test
  (:use :cl :fiveam :day06))
(in-package :day06-test)

(def-suite* day06-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "06")))
        (is (= 5346286649122 (day06::part01 content)))))

(test part02
      (let ((content (utils:read-input "06")))
        (is (= 10389131401929 (day06::part02 content)))))
