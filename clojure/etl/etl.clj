(ns etl
  (:use [clojure.string :only [lower-case]]))

(defn transform
  "Transform a map of {key [value]} to {(lower-case value) key}"
  [input]
  (reduce-kv #(merge %1 (zipmap (map lower-case %3) (repeat %2))) {} input))