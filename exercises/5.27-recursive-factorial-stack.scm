(load "5.26-29-eceval-batch.scm")

(define (eceval-prebatch-command-recursive-5.27) 
    '(define (f n)
      (if (= n 1)
          1
          (* (f (- n 1)) n)))
)

(define (eceval-prebatch-command-with-nested-call)
    '(define (f x)
        (define (factorial n)
          (if (= n 1)
              1
              (* (f (- n 1)) n)))
        (factorial x))
)




;(define eceval-prebatch-command eceval-prebatch-command-recursive-5.27) (run-eceval)
;(define eceval-prebatch-command eceval-prebatch-command-with-nested-call) (run-eceval)



; n   total   max
; 1   16      8
; 2   48      13
; 3   80      18
; 4   112     23
; 9   272     48
; 10  304     53

; if they're both linear, then
; total = 32n - 16
; max = 5n + 3


;              Maximum depth     Number of Pushes
; ----------|-----------------|-------------------
; Recursive |    5n + 3       |     32n - 16
; factorial |                 |
; ----------|-----------------|-------------------
; Iterative |      10         |     35n + 29       This row from 5.26
; factorial |                 |
; 
; "The maximum depth is a measure of the amount of space used by the evaluator in carrying out the computation, 
; and the number of pushes correlates well with the time required."
; 
; Huh.  
; So the iterative function does not experience stack overflow, as expected.
; But the iterative version is also slower!? Due to the overhead of the nested function call?



; what about for a recursive version WITH a nested function call?
; n   total   max
; 1   26      8
; 2   68      13    
; 3   110     18
; 4   152     23
; 9   362     48
; 10  404     53

; max = 5n + 3 as before
; total = 42n - 16. ah that makes more sense. 