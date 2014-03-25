; didn't they DO this already in the main text??

(define nil ()) ; apparently MIT Scheme 9.1 needs this

(define (square-list items)
  (if (null? items)
      nil
      (cons 
        (square (car items))        ; <??>                
        (square-list (cdr items))   ; <??>
      )
  )
)

(define (square-list-map items)
  (map 
    (lambda (x) (square x))         ; <??> 
    items                           ; <??>
  )
)


(define (test-2.21)
    (define (test procedure)
        (newline)
        (display (procedure (list 1 2 3 4)))    ; should be (1 4 9 16)
    )

    (test square-list)
    (test square-list-map)
)

; (test-2.21)