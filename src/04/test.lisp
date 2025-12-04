(in-package :cl-user)
(defpackage :day04-test
  (:use :cl :fiveam :day04))
(in-package :day04-test)

(def-suite* day04-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "04")))
        (is (= 1502 (day04::part01 content)))))

(test part02
      (let ((content (utils:read-input "04")))
        (is (= 9083 (day04::part02 content)))))
