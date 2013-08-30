(ns school)

(defn add
  "Add a student to the school's roster for a specific grade"
  [db name grade]
  (merge-with concat db {grade [name]}))

(defn grade
  "Roster of students in a specific grade by insertion order"
  [db grade]
  (db grade []))

(defn sorted
  "Map of grade to sorted student roster"
  [db]
  (reduce-kv #(assoc %1 %2 (sort %3)) {} db))
