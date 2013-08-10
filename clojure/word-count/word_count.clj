(ns phrase
  (:use [clojure.string :only [lower-case split blank?]]))
(defn- normalize [s] (lower-case s))
(defn- words [s] (remove blank? (split s #"\W+")))
(defn- word-to-count-map [word] {word 1})

(defn word-count [s]
  "Count the occurrences of each word (one or more contiguous case normalized
  characters that are not punctuation or whitespace) in a string"
  (->> s
       normalize
       words
       (map word-to-count-map)
       (apply merge-with +)))