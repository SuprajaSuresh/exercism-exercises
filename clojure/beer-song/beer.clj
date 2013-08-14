(ns beer
  (:use [clojure.string :only [capitalize]]))

(defn- bottles [num]
  (cond
   (zero? num) "no more bottles of beer"
   (= 1 num)   "1 bottle of beer"
   :else       (str num " bottles of beer")))

(defn- on-the-wall [num]
  (let [phrase (bottles num)]
    (str (capitalize phrase) " on the wall, " phrase ".")))

(defn- take-down [num]
  (if (>= num 0)
    (str "Take "
         (if (zero? num) "it" "one")
         " down and pass it around, "
         (bottles num)
         " on the wall.")
    "Go to the store and buy some more, 99 bottles of beer on the wall."))

(defn verse
  "Sing a verse of 99 bottles of beer on the wall"
  [num]
  (str (on-the-wall num) "\n" (take-down (dec num)) "\n"))

(defn sing
  "Sing verses from start down to end (inclusive)"
  ([start] (sing start 0))
  ([start end] (apply str (interleave
                           (map verse (range start (dec end) -1))
                           (repeat "\n")))))