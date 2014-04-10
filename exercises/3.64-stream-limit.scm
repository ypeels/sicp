; examine the stream until it finds two successive elements that differ in absolute value by less than the tolerance, 
; and return the second of the two elements
(define (stream-limit str tol)
    (let ((current (stream-car str)) (next (stream-ref str 1)))
        (if (< (abs (- current next)) tol)
            next
            (stream-limit (stream-cdr str) tol)
        )
    )
)



(define (test-3.64)
    (load "3.63-sqrt-stream-and-local-vars.scm")
    
    ; from problem statement
    (define (sqrt x tolerance)
      (stream-limit (sqrt-stream x) tolerance))
      
    (display (sqrt 2. .1)) ; 1.416666666
)
; (test-3.64)