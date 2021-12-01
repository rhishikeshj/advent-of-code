(ns advent-of-code.2019.day1)

;; Part 1

;; Below code is only required for reading the numbers from a file
(defn parse-int
  [string]
  (Integer. string))

(defn get-inputs []
   (with-open [rdr (clojure.java.io/reader "src/advent_of_code/2019/day1.txt")]
     (reduce conj [] (map parse-int (line-seq rdr)))))

;; Actual code to solve part 1
(defn get-fuel
  [mass]
  (- (int (Math/floor (/ mass 3))) 2))

(defn get-module-fuel
  [mass]
  (let [fuel-for-mass (get-fuel mass)]
    (if (> fuel-for-mass 0)
      (+ fuel-for-mass (get-module-fuel fuel-for-mass))
      0)))

(defn get-fuel-required
  [masses]
  (reduce + 0 (map get-module-fuel masses)))
