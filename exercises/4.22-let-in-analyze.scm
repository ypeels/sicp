; it was just a one-line modification to (analyze)!
    ; got to reuse ALL of the (let->combination) code from Exercise 4.6.

(load "4.22-24-ch4-analyzingmceval.scm")
    
(display "\n\nExercise 4.22 demo")
(display "\nTry, say, `(let ((x 0)) (+ x 1))` at the M-Eval prompt.")
(display "\nIt won't work if you comment out the Exercise 4.22 one-liner in ch4-analyzingmceval.scm")

(driver-loop)