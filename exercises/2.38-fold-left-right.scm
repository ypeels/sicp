; looks pretty easy, but the (fold) procedures are used in 2.39, so...

(load "2.33-37-accumulate.scm")

; "The accumulate procedure is also known as fold-right"
(define fold-right accumulate)

; from problem statement
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))
  
  
(define (test-2.38)

    (define nil ())                                             
    
    (define (test op initial sequence)
        (display "\nfold-right: ") (display (fold-right op initial sequence))
        (display "\nfold-left: ") (display (fold-left op initial sequence))
    )
    
    
    ; plug and chug! feels like high school!!
    (test / 1 (list 1 2 3))
    ; right: 3/2
    ; left:  1/6
    
    (test list nil (list 1 2 3))
    ; right: (1 (2 (3 ())))
    ; left: (((() 1) 2) 3)
    
    (test * 1 (list 1 2 3)) ; both 6
    (test + 0 (list 1 2 3)) ; both 6
    (test - 0 (list 1 2 3)) ; right: +2, left: -6

)

; (test-2.38)

; i BET the desired property is commutativity; addition and multiplication should work, subtraction should not

; proof for (length sequence) == 2 (other cases should follow by recursion)

; (fold-left op initial (list 1 2))
    ; = (iter initial (list 1 2)
    ; = (iter   (op initial 1)
    ;           (list 2))
    ; = (iter (op (op initial 1) 2) ())
    ; = (op (op initial 1) 2).
    
; (fold-right op initial (list 1 2))
    ; = (accumulate op initial (list 1 2))
    ; = (op 1 (accumulate op initial (list 2)))
    ; = (op 1 (op 2 (accumulate op initial ())))
    ; = (op 1 (op 2 initial))
    
; therefore a necessary condition is that
    ; ((0 op 1) op 2) == (1 op (2 op 0).
    ; to fulfill this condition, it suffices that (op) is commutative AND associative.

; that's all the problem asks for anyway. i BET it's sufficient too for n-long sequences, but don't feel like proving it...

; musings
    ; fold-left = initial op 1 op 2 op 3 op ... op n, evaluated from left to right.
    ; fold-right = 1 op 2 op 3 op ... op n op initial, EVALUATED FROM THE RIGHT. 
        ; even the initial value enters from the right
        ; (n op initial) is still evaluated in "left-to-right order", i.e., as (op n initial)