(ns cljfmt-graalvm.core-test
  (:require [clojure.test :refer [deftest is testing]]
            [cljfmt.core :as fmt]))

(deftest config
  (testing "Formatting using custom config"
    (let [input "(>defn create-ticket!
  [{:keys [status annotations labels] :as _alert}]
  [[:cat &input-schema] :any]
  (if true
    \"awesome\"))"]
      (is (= input
             (fmt/reformat-string input
                                  {:indents (merge fmt/default-indents {'>defn [[:inner 0]]})}))))

    (is (= "(>defn create-ticket!
  [{:keys [status annotations labels] :as _alert}]
  [[:cat &input-schema] :any]
  (if true
    \"awesome\"))"
           (fmt/reformat-string "(>defn create-ticket!
    [{:keys [status annotations labels] :as _alert}]
       [[:cat &input-schema] :any]
  (if true
    \"awesome\"))"
                                {:indents (merge fmt/default-indents {'>defn [[:inner 0]]})})))

    (let [input "(defn omsd
  []
  (if true
    :awesome))"]
      (is (= input
             (fmt/reformat-string input))))))
