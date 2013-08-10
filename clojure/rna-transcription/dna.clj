(ns dna)
(defn to-rna
  "RNA (ACGU) copy of the given DNA (ACGT) nucleotide string"
  [dna]
  (clojure.string/replace dna \T \U))