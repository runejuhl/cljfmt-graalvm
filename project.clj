(defproject cljfmt-graalvm :lein-v
  :description "Clojure formatter using cljfmt built with GraalVM"
  :url "https://gitlab.com/konrad.mrozek/cljfmt-graalvm"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [cljfmt "0.8.0"]
                 [org.clojure/tools.cli "1.0.206"]]
  :main cljfmt-graalvm.core
  :uberjar-name "cljfmt-graalvm-standalone.jar"
  :profiles {:uberjar {:jvm-opts ["-Dclojure.compiler.direct-linking=true"]
                       :aot      :all}}
  :plugins [[com.roomkey/lein-v "7.2.0"
             :middleware true
             :hooks      true]]
  :middleware [lein-v.plugin/middleware]
  :hooks      [lein-v.plugin/hooks])
