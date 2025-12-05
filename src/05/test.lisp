(in-package :cl-user)
(defpackage :day05-test
  (:use :cl :fiveam :day05))
(in-package :day05-test)

(def-suite* day05-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "05")))
        (is (= 617 (day05::part01 content)))))

(test part02
      (let ((content (utils:read-input "05")))
        (is (= 338258295736104 (day05::part02 content)))))
