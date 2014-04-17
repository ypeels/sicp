
(define (install-eight-queens)
    (ambeval-batch
    
        ; utility functions from exercise 2.42
        '(define (make-queen row col) 
            (cons row col))
        '(define (row-queen q) 
            (car q))
        '(define (col-queen q) 
            (cdr q))
            
        '(define (adjoin-position row col board)
            (append board (list (make-queen row col))))
        
        '(define (display-board board)
            (define (display-space n)
                (cond 
                    ((> n 0)
                        (display " ")
                        (display-space (- n 1)))
                    (else
                        'display-board-space-done)))

            (define (iter i)
                (cond 
                    ((<= i (length board))
                        (let ( (q (queen-board i board)) )
                        
                            ; fuck it, since they're in ascending order, cols will be horizontal
                            (display-space (- (row-queen q) 1))
                            (display "Q")
                            (newline)
                            (iter (+ i 1))  ; really? it's in here??
                        )
                    )   
                    
                    (else
                        'display-board-iter-done)
                )
            )
            
            (display "---------------\n")
            (iter 1)
        )
        
        ; extract the kth queen from the board
        '(define (queen-board j board)
            ;(if (and (<= 1 j) (<= j (length board))) ; ugh, my mceval doesn't support AND. meh don't feel like patching for ONE problem            
            (if (<= 1 j)
                (if (<= j (length board))
                    (list-ref board (- j 1))
                    (error "queen-board out of range" j (length board))
                )
                (error "queen-board out of range" j (length board))
            )
        )
        
        '(define empty-board '())
        
        '(define (check-queens? q1 q2)
            (let (  (r1 (row-queen q1)) (c1 (col-queen q1))
                    (r2 (row-queen q2)) (c2 (col-queen q2)))
                 

                (cond
                    ((= r1 r2) true);#t)  ; horizontal and vertical checks are easy
                    ((= c1 c2) true);#t)  
                    
                    ; diagonal check: |rise| = |run|
                    ((= (abs (- r1 r2)) (abs (- c1 c2))) true);#t)

                    (else false);#f)
                )
            )
        )
        
        ; this function returns true iff the kth queen in board is not in check by any other queen
        '(define (safe? k board)
            (define (iter j)
                (cond 
                
                    ; final termination: didn't get checked by any of the other queens
                    ((>= j k)
                        true);#t)

                    ; early termination: check!!
                    ((check-queens? (queen-board j board) (queen-board k board))
                        false);#f)
                        
                    ; next iteration
                    (else
                        (iter (+ j 1)))
                )
            )    
            
            ;(display-board board)
            ;(display (iter 1)) (newline)
            (iter 1)
        )

        
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end copy/pasting (with adaptations as needed)
        
        
        ; need to adapt the main procedure. 
        ; COULD hard code 8 queens, since the problem doesn't ask for the n x n solution...
        ; 
        
        ; the non-deterministic spirit is to "be cool" and generate all possibilities, pruning afterwards?
        
        ; add a queen to col k (row specified by integer between)
        ; require that it's not in check
            ; i.e., read through the api from exercise 2.42
            ; use this instead of (distinct?), since it needs to check for diagonal checks anyway
        ; recurse to col k+1
        
        '(define (queens board-size)
            (define (iter i board)
                (if (> i board-size)
                    board
                    (begin
                    
                        ; ok, the advantage of amb is that you don't have to worry about map/filter logic
                        (let ((new-board (adjoin-position (an-integer-between 1 board-size) i board)))
                            (require (safe? i new-board))
                            (iter (+ i 1) new-board)
                        )
                    
                    )
                )
            )
            (iter 1 empty-board)
        )
        
        ; could this have been made shorter without using all the old support functions?
                    
                    
                    
                    
                
                
         

        ; quickie "hello board"
        ;'(display (display-board (list (cons 1 2) (cons 2 1))))
        
        '(define (q) (display-board (queens 4))) ; and `try-again` to see more solutions
        '(define (f) (display-board (queens 5)))
        '(define (eight-queens) (display-board (queens 8))) ; this is really slow, though... not sure if it's my algorithm's fault or ambeval's...
    )
)


(define (test-4.44)
    (load "ch4-ambeval.scm")
    
    (load "4.35-an-integer-between-by-amb.scm")
    (install-integer-between)
    
    (load "4.35-37-require.scm") 
    (install-require)
    
    (install-eight-queens)
    (driver-loop)
)
;(test-4.44)
