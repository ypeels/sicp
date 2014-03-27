(define (print x)
    (newline)
    (display x)
)

                                                    ; Guesses from following the rules from my notes on Section 2.3.1
(print (list 'a 'b 'c))                             ; (a b c)
(print (list (list 'george))                    )   ; ((george))
(print (cdr '((x1 x2) (y1 y2)))                 )   ; ((y1 y2))
(print (cadr '((x1 x2) (y1 y2)))                )   ; (y1 y2)
(print (pair? (car '(a short list)))            )   ; #f - (car) evaluates to 'a
(print (memq 'red '((red shoes) (blue socks)))  )   ; #f
(print (memq 'red '(red shoes blue socks))      )   ; (red shoes blue socks)