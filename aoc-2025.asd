(asdf:defsystem :aoc-2025
  :depends-on (:trivia :alexandria :str :arrows)
  :components ((:file "src/utils")
               (:file "src/01/main")
               (:file "src/02/main")))

(asdf:defsystem :aoc-2025/test
  :depends-on (:aoc-2025 :fiveam)
  :components ((:file "src/01/test")
               (:file "src/02/test"))
  :perform (asdf:test-op (op c)
                         (uiop:symbol-call :fiveam :run!)))
