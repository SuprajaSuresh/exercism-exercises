(ns phrase
  (:use [clojure.string :only [lower-case split blank?]]))

(defn- words [s] (remove blank? (split s #"\W+")))

(defn word-count [s]
  "Count the occurrences of each word (one or more contiguous case normalized
  characters that are not punctuation or whitespace) in a string"
  (->> s
       lower-case
       words
       frequencies))