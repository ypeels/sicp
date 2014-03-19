(define (count-change amount)
    (cc amount 5))
    
; cc(a, k)
(define (cc amount kinds-of-coins)
    (cond   ((= amount 0) 1)                        ; made exact change by counting down!
            ((or    (< amount 0)                    ; could not make EXACT change (important for funny amounts, non-descending coin order, etc.)
                    (= kinds-of-coins 0))           ; coin bank is empty (edge case)
                0)
            (else (+ 
            
                ; Branch 1: cc(a, k-1) - # ways NEVER using the kth coin
                (cc amount 
                    (- kinds-of-coins 1))
                
                ; Branch 2: cc(a - d(k), k) - # ways using the kth coin ONCE (with value = d(k)
                (cc (- amount (first-denomination kinds-of-coins))
                    kinds-of-coins)))))

                    


; DESCENDING order - k DECREASES in (cc), so the biggest coin is used first
(define (fd-textbook k)
    (cond   ((= k 1) 1)
            ((= k 2) 5)
            ((= k 3) 10)
            ((= k 4) 25)
            ((= k 5) 50)
            (else 0)))      ; added an extra corner case to punish any jokers
          
; same as textbook, except reversed order of computations to reflect logic better, and possibly faster?
(define (fd-descending k)
    (cond 
            ((= k 5) 50)
            ((= k 4) 25)
            ((= k 3) 10)
            ((= k 2) 5)
            ((= k 1) 1)
            (else 0)))
                    
; use pennies first. should be WAY less efficient? 
; but the reason for the (< amount 0) test becomes much more obvious
(define (fd-ascending k)
    (cond   ((= k 1) 50)
            ((= k 2) 25)
            ((= k 3) 10)
            ((= k 4) 5)
            ((= k 5) 1)
            (else 0)))      ; added an extra corner case to punish any jokers

            
; pick a definition to test performance? count # cursor blinks
; $1.00: all 3 are indistinguishably fast
; $4.00 (26517): textbook cursor 8, descending 10 (guess i was wrong), ascending 12 (right about this though)
;(define (first-denomination kinds-of-coins) (fd-textbook kinds-of-coins) )
;(define (first-denomination kinds-of-coins) (fd-descending kinds-of-coins) )
(define (first-denomination kinds-of-coins) (fd-ascending kinds-of-coins) )


; found an answer to the iterative "challenge" at http://c2.com/cgi/wiki?SicpIterationExercise
; as the book suggests, an iterative implementation is considerably more complicated.
; well, i mean, in C and given a fixed coin bank of k coins, you could always hard-code a horrible k-nested loop...
    ; inelegant/inefficient, but SHORT and easy to understand, similar to the recursive approach...