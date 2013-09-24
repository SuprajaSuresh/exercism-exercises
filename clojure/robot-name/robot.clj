(def letters
  (map char (range (int \A) (int \Z))))

(def robot-names
  (atom (for [letter1 letters
              letter2 letters
              number  (range 1000)]
          (format "%s%s%03d" letter1 letter2 number))))

(defn- next-robot-name! []
  (first (swap! robot-names rest)))

(defn robot []
  (atom (next-robot-name!)))

(defn robot-name [robot]
  (deref robot))

(defn reset-name [robot]
  (swap! robot (constantly (next-robot-name!))))