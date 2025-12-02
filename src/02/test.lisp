(in-package :cl-user)
(defpackage :day02-test
  (:use :cl :fiveam :day02))
(in-package :day02-test)

(def-suite* day02-test :in cl-user::aoc-2025/test)

(test part01
  (let ((content (utils:read-input "02")))
    (is (= 28146997880 (day02::part01 content)))))

(test part02
  (let ((content (utils:read-input "02")))
    (is (= 40028128307 (day02::part02 content)))))
