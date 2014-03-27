(load "2.42-eight-queens-puzzle.scm")

(define (queens-louis-reasoner board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap                                                   ; run the inner "loop" for each possible value of new-row
             (lambda (new-row)
               (map (lambda (rest-of-queens)                        ; add new queen at (new-row, k) to (queen-cols (- k 1))
                      (adjoin-position new-row k rest-of-queens))   
                    (queen-cols (- k 1))))                          ; <------- the problem is that louis is re-computing 
             (enumerate-interval 1 board-size))                     ;          (queen-cols (- k 1)) for EACH NEW ROW
        )))
  (queen-cols board-size))
  
  
(define queens queens-louis-reasoner) ; is his name supposed to sound like "Loose Reasoner"?
; (test-2.42) ; n = 6 is a few seconds on a 2010-vintage Intel Core i7-870... Louis' patience point is probably n = 7 now.
; so louis' version DOES get the right answers, but the scaling in time is very unfavorable...


; oh come on, sicp-solutions, you skipped 2.43?
; so if you assume n = 8 and run time is proportional to the number of checks...?
; adding the first queen: runs (queen-cols 0) 8 times
; adding the second queen: runs (queen-cols 1) 8 times, which means running (queen-cols 0) 8^2 times...
; adding the third queen: runs (queen-cols 2) 8 times, which means running (queen-cols 0) 8^3 times...
; ...
; but how many checks are computed each time??  the tree is being pruned with each iteration by (filter)...
; oh that's right, each iteration generates (board-size) new boards, which are passed to (safe?)
    ; BUT how many checks are computed? the more queens there are already on the board, the faster you'll get checked,
        ; the faster (safe?) will terminate...
        
; in any case, you COULD estimate T^8, because the process is tree-recursive in invoking (queen-cols)
    ; but the cost of running of each (queen-cols) is different...meh
    ; http://wiki.drewhess.com/wiki/SICP_exercise_2.43 claims T^7?? mehhhhhh


