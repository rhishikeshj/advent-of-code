(ns advent-of-code.2019.day2)

(def input* [1,12,1,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,5,23,1,23,9,27,2,27,6,31,1,31,6,35,2,35,9,39,1,6,39,43,2,10,43,47,1,47,9,51,1,51,6,55,1,55,6,59,2,59,10,63,1,6,63,67,2,6,67,71,1,71,5,75,2,13,75,79,1,10,79,83,1,5,83,87,2,87,10,91,1,5,91,95,2,95,6,99,1,99,6,103,2,103,6,107,2,107,9,111,1,111,5,115,1,115,6,119,2,6,119,123,1,5,123,127,1,127,13,131,1,2,131,135,1,135,10,0,99,2,14,0,0])

(def target* 19690720)

(defn execute-op
  [op-code opA opB data]
  (case op-code
    1 (+ (nth data opA) (nth data opB))
    2 (* (nth data opA) (nth data opB))
    nil))

(defn execute-step
  [step data]
  (when (= (count step) 4)
      (let [op-code (first step)
            opA (second step)
            opB (nth step 2)
            output (nth step 3)]
        (execute-op op-code opA opB data))))

(defn execute-next-step
  [index data]
  (let [opcodes (nthrest data index)
        step (take 4 opcodes)
        result (execute-step step data)]
    (if result
      (execute-next-step (+ index 4) (assoc data (last step) result))
      data)))

(def values* (for [noun (range 0 99)
                   verb (range 0 99)]
               (if (= target* (first (execute-next-step 0 (assoc (assoc input* 1 noun) 2 verb))))
                 {:noun noun :verb verb}
                 nil)))

(some identity values*)
