(define x (list 1 2 3))
(define y (list 4 5 6))
                                      ; my guess
(newline) (display (append x y))      ; (1 2 3 4 5 6)
(newline) (display (cons x y))        ; ((1 2 3) . (4 5 6)) - a raw pair? WRONG: ((1 2 3) 4 5 6). still a list since y is NULL-TERMINATED.
(newline) (display (list x y))        ; ((1 2 3) (4 5 6))   - a list of lists