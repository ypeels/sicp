(load "3.66-72-streams-of-pairs.scm")

; first try SLIGHTLY modifying (pairs), replacing interleave with merge-weighted
(define (weighted-pairs s t weight)

  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted                                          ; previously (interleave 
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight                                                  ; new argument
   )))
   
   
; try SLIGHTLY modifying (merge) from Exercise 3.56
(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2))
               (w1car (weight (stream-car s1)))             ; new
               (w2car (weight (stream-car s2))))
           (cond ((<= w1car w2car)                          ; previously (< s1car s2car). let ties favor s1, arbitrarily
                  (cons-stream s1car (merge-weighted (stream-cdr s1) s2 weight)))
                 ;((> s1car s2car)                          ; pairs are guaranteed distinct, but weights may tie
                 ; (cons-stream s2car (merge-weighted s1 (stream-cdr s2 weight))))
                 (else
                  (cons-stream s2car                        ; previously s1car
                               (merge-weighted s1           ; previously (stream-cdr s1)
                                      (stream-cdr s2)
                                      weight))))))))        ; new argument
                                      
(define (test-3.70)

    (define (iter i stream)
        (if (>= i 0)
            (begin
                (newline)
                (display (stream-car stream))
                (iter (- i 1) (stream-cdr stream))
            )
        )
    )
        
            

    ; a. the stream of all pairs of positive integers (i,j) with i < j ordered according to the sum i + j
    (display "\nExercise 3.70a\n")
    (iter 10 (weighted-pairs integers integers (lambda (pair) (+ (car pair) (cadr pair)))))
    ; 1 1
    ; 1 2
    ; 1 3 
    ; 2 2
    ; 1 4
    ; 2 3
    ; 1 5
    ; 2 4
    ; 3 3
    ; 1 6
    ; 2 5
    
    ; b. the stream of all pairs of positive integers (i,j) with i < j, 
    ; where neither i nor j is divisible by 2, 3, or 5, 
    ; and the pairs are ordered according to the sum 2 i + 3 j + 5 i j. 
    (define (not-divisible-by? x mod)
        (not (= 0 (remainder x mod))))
        
    (let ((indivisible-by-2-3-5 
            (stream-filter
                (lambda (x)
                    (and 
                        (not-divisible-by? x 2) 
                        (not-divisible-by? x 3) 
                        (not-divisible-by? x 5) 
                    )
                )
                integers
            )))
            
        
        (display "\nExercise 3.70b\n")
        (iter 10
            (weighted-pairs
                indivisible-by-2-3-5
                indivisible-by-2-3-5 
                (lambda (pair)
                    (let ((i (car pair)) (j (cadr pair)))
                        (+ (* 2 i) (* 3 j) (* 5 i j))
                    )
                )
            )
        )
    )
    ; 1 1
    ; 1 7
    ; 1 11
    ; 1 13
    ; 1 17
    ; 1 19
    ; 1 23
    ; 1 29
    ; 1 31
    ; 7 7
    ; 1 37. who knows if this is right...
    
            
            
            
    
)
; (test-3.70)
    