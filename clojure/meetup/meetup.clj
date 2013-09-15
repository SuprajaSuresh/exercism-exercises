(ns meetup
  (:import (java.util GregorianCalendar)))
;; This exercise has a terrible API. Using symbols would've been a far better
;; choice than this combinatorial explosion of exported functions.
;; I guess this is really an exercise about metaprogramming and not dates?

(def ^:const ^:private weekdays
  {"sunday"    (GregorianCalendar/SUNDAY)
   "monday"    (GregorianCalendar/MONDAY)
   "tuesday"   (GregorianCalendar/TUESDAY)
   "wednesday" (GregorianCalendar/WEDNESDAY)
   "thursday"  (GregorianCalendar/THURSDAY)
   "friday"    (GregorianCalendar/FRIDAY)
   "saturday"  (GregorianCalendar/SATURDAY)})

(def ^:const ^:private DOW (GregorianCalendar/DAY_OF_WEEK))

(def ^:const ^:private DOM (GregorianCalendar/DAY_OF_MONTH))

(def ^:const ^:private ordinals
  {"first"  0
   "second" 1
   "third"  2
   "fourth" 3})

(defn- remove-day [s]
  (subs s 0 (- (count s) 3)))

(defn- set-weekday-forward! [cal weekday]
  (let [delta (- weekday (.get cal DOW))]
    (.add cal DOM (if (< delta 0) (+ delta 7) delta))))

(defn- set-weekday-reverse! [cal weekday]
  (let [delta (- weekday (.get cal DOW))]
    (.add cal DOM (if (> delta 0) (- delta 7) delta))))

(defn- set-end-of-month! [cal]
  (.set cal DOM (.getActualMaximum cal DOM)))

(defn- to-cal [year month date]
  (GregorianCalendar. year (dec month) date))

(defn- from-cal [cal]
  [(.get cal GregorianCalendar/YEAR)
   (inc (.get cal GregorianCalendar/MONTH))
   (.get cal DOM)])

(defmacro ^:private with-cal [year-month-date & forms]
  `(from-cal (doto (to-cal ~@year-month-date) ~@forms)))

;; first-sunday through fourth-saturday
(doseq [[ord-name ord] ordinals
        [weekday-name weekday] weekdays]
  (let [fname (symbol (str ord-name "-" weekday-name))
        start-day (inc (* 7 ord))]
    (eval
     `(defn ~fname [month# year#]
        (with-cal [year# month# ~start-day]
          (set-weekday-forward! ~weekday))))))

;; last-sunday through last-monday
(doseq [[weekday-name weekday] weekdays]
  (let [fname (symbol (str "last-" weekday-name))]
    (eval
     `(defn ~fname [month# year#]
        (with-cal [year# month# 1]
          (set-end-of-month!)
          (set-weekday-reverse! ~weekday))))))

;; sunteenth through saturteenth
(doseq [[weekday-name weekday] weekdays]
  (let [fname (symbol (str (remove-day weekday-name) "teenth"))]
    (eval
     `(defn ~fname [month# year#]
        (with-cal [year# month# 13]
          (set-weekday-forward! ~weekday))))))