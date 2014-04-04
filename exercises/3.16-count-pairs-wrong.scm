; Ben Bitdiddle is FALLIBLE!?

; from problem statement
(define (count-pairs x) 
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))                               ; this function returns the number of pairs it ever enters via car/cdr
        
;(define (get-new-pair)
;    (cons '() '())
;)
;    
;(define a (get-new-pair))
;(define b (get-new-pair))
;(define c (get-new-pair))       

         

(define (display-count description x)
    (newline)
    (newline) (display description)
    (newline) (display x)
    (display "\nresult of (count-pairs: ")
    (display (count-pairs x))
)
         

; the following data structures are patently composed of 3 pairs each.
; the incorrectness of Ben's algorithm has NOTHING to do with mutability, just the perverseness of the structures.
; ben's algorithm would have been FINE if there were only ONE way to enter each pair
    ; trees would be fine!
         
; count returns 3: a simple list
(define c3 (cons 2 '()))                    ; (set-car! a 0) (set-cdr! a b)
(define b3 (cons 1 c3))                     ; (set-car! b 1) (set-cdr! b c)
(define a3 (cons 0 b3))                     ; (set-car! c 2) (set-cdr! c '())
(display-count "simple list" a3)            ; (0 1 2)


; count returns 4: aliased final node - 1 + 1 + 2
(define c4 (cons 3 '()))                    ; (set-car! a 0) (set-cdr! a b)
(define b4 (cons c4 c4))                    ; (set-car! b c) (set-cdr! b c)
(define a4 (cons 0 b4))                     ; (set-car! c 3) (set-cdr! c '())
(display-count "aliased list" a4)           ; (0 (3) 3) 


; count returns 7: alias EVERYTHING - 1 + 2 + 4
(define c7 (cons 4 '()))                    ; (set-car! a b) (set-cdr! a b)               
(define b7 (cons c7 c7))                    ; (set-car! b c) (set-cdr! b c)
(define a7 (cons b7 b7))                    ; (set-car! c 4) (set-cdr! c '())
(display-count "fully aliased" a7)          ; (((4) 4) (4) 4)
                                            ; c7 = (4)
                                            ; b7 = ((4) 4)
                                            ; a7 = ( b7 . b7 ) = ( ((4) 4) (4) 4 )



; the only example that requires mutability seems to be "never return at all" (you can't use a cyclic define; you'll get an "unbound variable" error
(define cinf (cons 2 '()))
(define binf (cons 1 cinf))
(define ainf (cons 0 binf))

(define (final-test-3.16)

    (display "\ninfinite loop. are you ready?")
    (count-pairs a3)    ; Aborting!: maximum recursion depth reached
    (display "\nwhy can't i die!?")
)
;(final-test-3.16) ; disabled so that the test data can be reused for exercise 3.17
