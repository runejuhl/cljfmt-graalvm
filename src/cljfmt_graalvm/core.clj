(ns cljfmt-graalvm.core
  (:require [cljfmt.core :as fmt])
  (:gen-class))

(defn ^:private usage
  []
  (println (format "Usage: cljfmt [files...|-]

Run cljfmt on one of more files. If the arguments contain \"-\" read and write to stdin/stdout instead."))
  (flush)
  (System/exit 0))

(defn format-file
  [file]
  (->> file
       (slurp)
       (fmt/reformat-string)
       (spit file)))

(defn -main
  [& args]
  (when (some (partial = "-h") args)
    (usage))
  (when (some (partial = "-") args)
    (print (fmt/reformat-string (slurp *in*)))
    (flush)
    (System/exit 0))
  (run! format-file
        args))
