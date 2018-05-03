(defproject cljfmt-graalvm "0.1.0-SNAPSHOT"
  :description "Clojure formatter using cljfmt built with GraalVM"
  :url "https://gitlab.com/konrad.mrozek/cljfmt-graalvm"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [cljfmt "0.5.7"]]
  :main cljfmt-graalvm.core
  :profiles {:uberjar {:aot :all}})
