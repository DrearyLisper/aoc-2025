(in-package :cl-user)
(defpackage :day11-test
  (:use :cl :fiveam :day11))
(in-package :day11-test)

(def-suite* day11-test :in cl-user::aoc-2025/test)

(test part01
      (let ((content (utils:read-input "11")))
        (is (= 788 (day11::part01 content)))))

(test part02
      (let ((content (utils:read-input "11")))
        (is (= 316291887968000 (day11::part02 content)))))
