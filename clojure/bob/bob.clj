(ns bob)
(defn response-for
  [s]
  (cond
   (empty? s) "Fine, be that way."
   (= s (.toUpperCase s)) "Woah, chill out!"
   (= \? (last s)) "Sure."
   :else "Whatever."))
