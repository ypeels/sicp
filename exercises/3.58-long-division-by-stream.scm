; from problem statement
(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))
   


   
; 
; x = num, first term = (x * radix) / den
; recurse with x <- (x * radix) % den

; my interpretation: long-division, or "floating point representation" in base radix
    ; multiply numerator by radix because the ith term is understood to be the coefficient of radix**(-i)
    ; additional: the first term will account for the "whole number part" if num > den

(define (test num den radix num-terms)

    (let ((stream (expand num den radix)))
        (define (iter i)
            (newline) (display (stream-ref stream i))
            (if (< i num-terms)
                (iter (+ i 1)))
        )
        
        (newline) (newline) (display num) (display "/") (display den) (display " base ") (display radix)
        (iter 0)
    )
    

)

(test 1 7 10 8)
; 142857142


(test 3 8 10 8)
; 375000000