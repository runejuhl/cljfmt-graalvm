(ns cljfmt-graalvm.core
  (:require [cljfmt.core :as fmt]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.string]
            [clojure.java.io]
            [clojure.edn])
  (:gen-class))

(def cli-options
  ;; An option with a required argument
  [["-c" "--config FILE" "Config file"]
   ["-h" "--help"]
   ["-t" "--test" "Test only, output file to stdout"]])

(defn format-files
  [{:keys [arguments] {:keys [config test]} :options}]
  (let [format-config (when config
                        (with-open [f (clojure.java.io/reader config)]
                          (clojure.edn/read (java.io.PushbackReader. f))))
        merged-config (cond-> format-config
                        :indents (update :indents merge fmt/default-indents))]
    (run! (fn [file]
            (let [formatted (-> file
                                (slurp)
                                (fmt/reformat-string merged-config))]
              (if test
                (println formatted)
                (spit file formatted))))
          arguments)))

(defn err!
  "Print `args` to stderr and exit with `exit-code`."
  [exit-code & args]
  (binding [*out* *err*]
    (println (clojure.string/join \newline args)))
  (System/exit exit-code))

(defn -main
  [& _args]
  (let [{:keys [options errors summary] :as parsed-opts} (parse-opts _args cli-options)]
    (when errors
      (err! 255 (clojure.string/join "\n" errors)))

    (when (:help options)
      (err! 0 "Usage: cljfmt [-c CONFIG] FILE...\n" summary))

    (format-files parsed-opts)))

(comment
  (format-files
   (parse-opts '("-c" "/tmp/test/blah/.cljfmt.edn"
                      "/tmp/test/blah/src/blah/alert.clj")
               cli-options)))
