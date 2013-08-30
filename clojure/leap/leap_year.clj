;(ns leap)
(defn- has-factor [n d] (zero? (rem n d)))

(defn leap-year
  "Return true if the given year is a leap year"
  [year]
  (and (has-factor year 4)
       (or (not (has-factor year 100))
           (has-factor year 400))))
