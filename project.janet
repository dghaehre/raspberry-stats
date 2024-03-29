(declare-project
  :name "raspystatus"
  :description ""
  :dependencies ["https://github.com/joy-framework/joy"
                 "https://github.com/andrewchambers/janet-sh"
                 "https://github.com/janet-lang/sqlite3"]
  :author ""
  :license ""
  :url ""
  :repo "")

(phony "server" []
  (if (= "development" (os/getenv "JOY_ENV"))
      # TODO check if entr exists
    (os/shell "find . -name '*.janet' | entr janet main.janet")
    (os/shell "janet main.janet")))

(declare-executable
  :name "app"
  :entry "main.janet")
