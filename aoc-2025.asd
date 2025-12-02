(asdf:defsystem :aoc-2025
  :depends-on (:trivia :alexandria :str :arrows)
  :components ((:file "src/utils")
               (:file "src/01/main")
               (:file "src/02/main")))
