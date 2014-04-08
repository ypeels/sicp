(load "3.39-42-parallel-execute-and-serializer.scm")

(define (test)

    
    (let ((x 10) (s (make-serializer)))
    
        ; from problem statement
        (parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                          (s (lambda () (set! x (+ x 1)))))
                          
        (newline) (display x)
    )
)

; "new" value: 100
; parallelizer isn't working?
