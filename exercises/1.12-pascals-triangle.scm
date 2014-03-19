; B(0, k) = 1
; B(1, k) = 1 1
; B(2, k) = 1 2 1
; B(3, k) = 1 3 3 1
; ...
; For integers n, k
; B(n, k) = B(n-1, k-1) + B(n-1, k) for 0 <= k <= n
;           0 otherwise
; Seed with B(0, k) =   1 for k = 0
;                       0 otherwise

(define (binomial n k)

    ; "switch" with compound conditions is much clearer than nested if's
    ; - it's hard to even distinguish between the if-value and the else-value!! stupid scheme...
    ; - "if"'s in scheme are probably best suited for one-liners...
    (cond   
        ((= n 0) (if (= k 0) 1 0))        ; more like C's ternary operator than "if". automagically handles k < 0.
    
        ; the nominal case
        ((and (<= 0 k) (<= k n))
            (+  (binomial (- n 1) (- k 1))
                (binomial (- n 1) k)))
                
        ; "zero-pad: the triangle (automagically handles n < 0!)
        (else 0)))
    
(define (B n k) (binomial n k))
   

; HOW do you write a for loop with printf, just to check your results??? stupid scheme   
(newline)
(newline)
(write (B 0 0))(newline)
(write (B 1 0))(write (B 1 1))(newline)
(write (B 2 0))(write (B 2 1))(write (B 2 2))(newline)
(write (B 3 0))(write (B 3 1))(write (B 3 2))(write (B 3 3))(newline)



        