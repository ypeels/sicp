(define (inc x) (+ x 1))

(define (compose foo bar)
    (lambda (x) (foo (bar x))))


(define (test-1.42)
    (display ((compose square inc) 6))  ; 49
)

(test-1.42) ; for testing