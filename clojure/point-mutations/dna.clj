(ns dna)

(defn hamming-distance
  "Returns the hamming distance from DNA strand a to DNA strand b"
  [a b]
  (count (filter false? (map = a b))))