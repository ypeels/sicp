(define (make-segment start-vector end-vector)
    (cons start-vector end-vector))
(define (start-segment segment)
    (car segment))
(define (end-segment segment)
    (cdr segment))                  ; is that REALLY it??