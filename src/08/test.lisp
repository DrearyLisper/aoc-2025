(in-package :cl-user)
(defpackage :day08-test
  (:use :cl :fiveam :day08))
(in-package :day08-test)

(def-suite* day08-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "08")))
        (is (= 72150 (day08::part01 content)))))

(test part02
      (let ((content (utils:read-input "08")))
        (is (= 3926518899 (day08::part02 content)))))
