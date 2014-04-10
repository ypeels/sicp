(define (smooth s)
    (cons-stream                        ; sols: ohh you can use stream-map. but i don't think the sol itself is quite right...
        (/
            (+  (car-stream s)
                (car-stream (cdr-stream s))
            )
            2
        )
        (smooth (cdr-stream s))
    )
)

(define smoothed-data (smooth sense-data))

(define zero-crossings
    (stream-map sign-change-detector smoothed-data (cons-stream 0 smoothed-data))) ; really kissing up now