(ns phone)
(defn number
  "Return the 10 digits of a phone number, or 0000000000 if it is invalid"
  [raw-number]
  (let [digits (re-seq #"\d" raw-number)
        num-digits (count digits)]
    (cond
     (and (= num-digits 11) (= "1" (first digits))) (apply str (rest digits))
     (= num-digits 10)                              (apply str digits)
     :else                                          "0000000000")))

(defn area-code
  "get the area code from a number"
  [raw-number]
  (subs (number raw-number) 0 3))

(defn pretty-print
  "pretty print a phone number as (212) 555-1212"
  [raw-number]
  (let [number (number raw-number)]
    (str "(" (subs number 0 3) ") " (subs number 3 6) "-" (subs number 6))))