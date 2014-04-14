; " Amazingly, Louis's intuition in exercise 4.20 is correct." talk about louis-bashing...

; the basic stupid trick is to pass a lambda TO ITSELF as an argument.
    ; that way, it has a name with which to refer to itself.
    
(define (factorial n)

    ; from problem statement
    ((lambda (n)
       ((lambda (fact)
          (fact fact n))                ; need initial call to pass the lambda to itself
        (lambda (ft k)                  ; basically (lambda (ft k)) is doing double duty - program AND data.
          (if (= k 1)
              1
              (* k (ft ft (- k 1)))))))
     n) ;10)
     
)

(define (test title proc)
    (define (test-n title n proc)
        (newline)
        (display title)
        (display " ")
        (display n)
        (display " = ")
        (display (proc n))
    )
    
    (newline) 
    (test-n title 1 proc)
    (test-n title 2 proc)
    (test-n title 3 proc)
    (test-n title 4 proc)
    (test-n title 5 proc)
    (test-n title 6 proc)
    (test-n title 7 proc)
)

    

;(test-factorial 0) ; "Aborting! maximum recursion depth reached"
(test "Factorial of" factorial)
; 1
; 2
; 6
; 24
; 120
; 720
; 5040
 

 
; let's do the same trick with the recursive formulation of fibonacci
(define (fibonacci n)

    ; first the basic infrastructure to enable "nameless recursion". is this the fabled Y-operator?
    ((lambda (n)
        ((lambda (fib)
            (fib fib n))
            
            ; modified from p. 37
            (lambda (f k)
                (cond 
                    ((= k 0) 0)
                    ((= k 1) 1)
                    (else
                        (+  (f f (- k 1))
                            (f f (- k 2))))
                )                            
            )
        ))
        n
    )
)

(test "Fibonacci of" fibonacci)
; 1
; 1
; 2
; 3
; 5
; 8
; 13


; skeleton from problem statement
(define (y-even? x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))));<??> <??> <??>)))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1)))))); <??> <??> <??>)))))
     
     ; function signatures tell you EVERYTHING
     ; third argument must be (- n 1) in both of them
     ; and there's no funny business going on - just recursively pass ev? and od? as references
(test "Is the following number even?" y-even?)