(ns cljfmt-graalvm.core
  (:require [cljfmt.core :as fmt])
  (:gen-class))

(defn -main
  [x]
  (let [s (fmt/reformat-string (slurp x))]
    (spit x s)))
