; from problem statement. original program from section 1.2.2, p. 41
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

; the second argument is a LIST now instead of an integer (used to index into a hard-coded list)
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)        ; changed from (= kinds-of-coins 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))    ; changed from (- kinds-of-coins 1)
            (cc (- amount
                   (first-denomination coin-values))        ; changed from (first-denomination kinds-of-coins)
                coin-values)))))                            ; changed from kinds-of-coins
                
                
                
; Exercise 2.19. yes, apparently the answer is just 3 lines...
(define (no-more? coins) (null? coins))
(define (first-denomination coins) (car coins))             ; seems to require rather low-level knowledge of how scheme lists work...
(define (except-first-denomination coins) (cdr coins))



(define (test-2.19)
    (newline)
    (display (cc 100 us-coins))     ; 292
   
    (newline)
    (display (cc 100 (reverse us-coins)))   ; 292
    ; list order does not affect the result because the original algorithm is robust against that
        ; in particular, testing for (< amount 0) will (inefficiently) rule out over-change (inexact)
        ; see my notes on section 1.2.2, kind of
   
)

;(test-2.19)