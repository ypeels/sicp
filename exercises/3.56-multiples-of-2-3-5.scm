(load "3.53-62-stream-operations.scm")

; A famous problem, first raised by R. Hamming, is to enumerate, in ascending order with no repetitions, 
; all positive integers with no prime factors other than 2, 3, or 5. 

; from problem statement
; combines two ordered streams into one ordered result stream, eliminating repetitions
(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< s1car s2car)
                  (cons-stream s1car (merge (stream-cdr s1) s2)))
                 ((> s1car s2car)
                  (cons-stream s2car (merge s1 (stream-cdr s2))))
                 (else
                  (cons-stream s1car
                               (merge (stream-cdr s1)
                                      (stream-cdr s2)))))))))
                                      
(define (test-3.56)

    ; from problem statement. fill in the blanks!
    (define S (cons-stream 1 (merge 
        ; <??> 
        (scale-stream S 2)
        
        ; <??>
        (merge (scale-stream S 3) (scale-stream S 5))
    )))
    
    (define (test n)
        (define (iter i)
            (if (<= i n)
                (begin
                    (newline)
                    (display (stream-ref S i))
                    (iter (+ i 1)) ; stupid scheme - all i want is a friggin for loop
                )
            )
        )
        (iter 0)        
    )
    (test 20)
)
(test-3.56)
; 1 2 3 4 5 6 8 9 10 12 15 16 18. hmmmm missed 14... does order matter?