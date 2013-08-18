(ns dna
  (:refer-clojure :exclude [count]))

(def ^:private nucleotides
  #{"A" "C" "G" "T" "U"})

(def ^:private dna-nucleotides
  #{"A" "C" "G" "T"})

(def ^{:private :const} dna-nucleotide-map
  (apply hash-map (interleave dna-nucleotides (repeat 0))))

(defn- normalize-nucleotide
  [valid-nucleotides input]
  (if (nil? (valid-nucleotides input))
    (throw (Exception. (str "invalid nucleotide '" input "'")))
    input))

(defn- nucleotides-from-str [valid-nucleotides input]
  (map (partial normalize-nucleotide valid-nucleotides) (re-seq #"." input)))

(defn nucleotide-counts
  "DNA nucleotide counts (A, C, G, T) for the given strand as {string integer}"
  [strand]
  (merge dna-nucleotide-map
         (frequencies (nucleotides-from-str dna-nucleotides strand))))

(defn count
  "Return the number of times nucleotide occurs in strand"
  [nucleotide strand]
  (let [valid-nucleotide (normalize-nucleotide nucleotides nucleotide)]
    (->> (nucleotides-from-str nucleotides strand)
         (filter #(= valid-nucleotide %))
         (clojure.core/count))))