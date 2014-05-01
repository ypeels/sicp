(load "5.26-29-eceval-batch.scm")

(define (eceval-prebatch-command) 
    '(define (f n) ;(factorial n)
      (define (iter product counter)
        (if (> counter n)
            product
            (iter (* counter product)
                  (+ counter 1))))
      (iter 1 1))
)

(run-eceval)

; a. You will find that the maximum depth required to evaluate n! is independent of n. What is that depth?
; n maximum-depth
;<1 8
; 1 10
; 2 10 
; 3 10
; 9 10

; That depth is 10.

; b. Determine from your data a formula in terms of n for the total number of push operations used in 
; evaluating n! for any n > 1. Note that the number of operations used is a linear function of n and is 
; thus determined by two constants. 
; n   total
; <1  29
; 1   64
; 2   99
; 3   134
; 4   169
; 9   344 = (350 - 35) + 29. yup.

; slope is 35
; origin is 29

; The total number of push operations is 35n + 29.