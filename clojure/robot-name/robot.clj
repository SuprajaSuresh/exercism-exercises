;The tests don't seem to expect a namespace?
;(ns robot)

(defn- rand-chars [lo hi]
  (let [lo-cp (int lo)
        hi-cp (int hi)]
    (repeatedly #(char (+ lo-cp (rand-int (- hi-cp lo-cp)))))))

(defn- rand-name []
  (apply str (concat (take 2 (rand-chars \A \Z))
                     (take 3 (rand-chars \0 \9)))))

(defn robot
  "Return a new robot"
  []
  (atom (rand-name)))

(defn robot-name
  "Get the name of a robot"
  [robot]
  (deref robot))

(defn reset-name
  "Reset the name of a robot"
  [robot]
  (let [new-name (rand-name)]
    (swap! robot (fn [_] new-name))))
