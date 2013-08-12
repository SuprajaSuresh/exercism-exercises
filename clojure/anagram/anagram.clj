(ns anagram)
(defn anagrams-for
  "The subset of possible-anagrams that are an anagram of given-word"
  [given-word possible-anagrams]
  (let [given-word-freq (frequencies given-word)
        has-same-freq? #(= given-word-freq (frequencies %))]
    (filter has-same-freq? possible-anagrams)))