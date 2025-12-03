(in-package :cl-user)
(defpackage :day03-test
  (:use :cl :fiveam :day02))
(in-package :day03-test)

(def-suite* day03-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "03")))
        (is (= 17694 (day03::part01 content)))))

(test part02
      (let ((content (utils:read-input "03")))
        (is (= 175659236361660 (day03::part02 content)))))
