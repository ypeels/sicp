; from ch3support.scm
(define (print-n s n)
  (if (> n 0)
      (begin (newline)
	     (display (stream-car s))
             (print-n (stream-cdr s) (- n 1)))))

; from problem statement
(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
                        (stream-car input-stream))))

;(define zero-crossings (make-zero-crossings sense-data 0))


; had to add this
; "takes two values as arguments and compares the signs of the values to produce an appropriate 0, 1, or - 1"
; "(Assume that the sign of a 0 input is positive.)"
(define (sign-change-detector current previous)
    (cond
        ; + 1 whenever the input signal changes from negative to positive,
        ((and (< previous 0) (>= current 0))
            +1)
            
        ; - 1 whenever the input signal changes from positive to negative
        ((and (>= previous 0) (< current 0))
            -1)
        
        ; and 0 otherwise
        (else 0)
    )
)


            
            
(define (test-3.74)

    (define input-list '(1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4))
    (define (list-to-stream L)
        (if (null? L)
            the-empty-stream
            (cons-stream 
                (car L)
                (list-to-stream (cdr L))
            )
        )
    )
    (define input-stream (list-to-stream input-list))
    
    ; they assume 0 initially, even though it is "positive"
    (print-n (make-zero-crossings input-stream 0) (- (length input-list) 1))   
    ; 0 0 0 0 0 -1 0 0 0 0 1 0 0
    
    
    (define zero-crossings
      (stream-map sign-change-detector input-stream (stream-cdr input-stream)));sense-data <expression>))
                                                        ; <expression> = (stream-cdr input-stream)
    
    (display "\n\nExercise 3.74 - Eva Lu Ator's one-liner\n")
    (print-n zero-crossings (- (length input-list) 1))   
    ; 0 0 0 0 1 0 0 0 0 -1 0 0
    ; "approximately equivalent" because it skips the first element 
    
)
; (test-3.74)
    
    