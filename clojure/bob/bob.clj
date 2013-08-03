(ns bob)
(defn response-for
  "Bob's response to the given fragment of conversation"
  [s]
  (cond
   ;; Nothing was said 
   (empty? s) "Fine, be that way."
   ;; YELLING IN ALL CAPS.
   (= s (clojure.string/upper-case s)) "Woah, chill out!"
   ;; A question?
   (= \? (last s)) "Sure."
   ;; Default response
   :else "Whatever."))
