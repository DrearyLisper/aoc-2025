(in-package :cl-user)
(defpackage :day10-test
  (:use :cl :fiveam :day10))
(in-package :day10-test)

(def-suite* day10-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "10")))
        (is (= 547 (day10::part01 content)))))
