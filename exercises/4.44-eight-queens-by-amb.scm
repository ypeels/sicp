
(define (install-eight-queens)
    (ambeval-batch
    
        ; utility functions from exercise 2.42
        '(define (make-queen row col) 
            (cons row col))
        '(define (row-queen q) 
            (car q))
        '(define (col-queen q) 
            (cdr q))
        
        '(define (display-board board)
            (define (display-space n)
                (cond 
                    ((> n 0)
                        (display " ")
                        (display-space (- n 1)))
                    (else
                        "unused return value")))

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
                        "unused return value -- DISPLAY-BOARD")
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
                    ((= r1 r2) #t)  ; horizontal and vertical checks are easy
                    ((= c1 c2) #t)  
                    
                    ; diagonal check: |rise| = |run|
                    ((= (abs (- r1 r2)) (abs (- c1 c2))) #t)

                    
                    (else #f)
                )
            )
        )
        
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end copy/pasting (with adaptations as needed)
        
        
        ; need to adapt the main procedure. 
        ; COULD hard code 8 queens, since the problem doesn't ask for the n x n solution...
        ; 
        
        ; the non-deterministic spirit is to "be cool" and generate all possibilities, pruning afterwards?
        
        
        (define (queens board-size)
          (define (queen-cols k)  
            (if (= k 0)                                                         ; k = new # columns
                (list empty-board)                                              ; start with empty board
                (filter
                 (lambda (positions) (safe? k positions))                       ; weed out any positions in check    
                 (flatmap                                                       ; create list of new boards with a queen added somewhere SAFE in column k
                  (lambda (rest-of-queens)                                      
                    (map (lambda (new-row)
                           (adjoin-position new-row k rest-of-queens))          ; adds new position (new-row, k): queen in column k...
                         (enumerate-interval 1 board-size)))                        ; ...for all rows.
                  (queen-cols (- k 1))))))                                      ; recursion/next iteration
          (queen-cols board-size))                                              ; start first iteration
        
        
        (define (queens board-size)
            (define (
                
         

        ; quickie "hello board"
        ;'(display (display-board (list (cons 1 2) (cons 2 1))))
        
        '(define (q) (display-board (queens 4))) ; and `try-again` to see more solutions
    
    )
)


(define (test-4.44)
    (load "ch4-ambeval.scm")
    
    
    ;(load "4.35-37-require.scm") (install-require)
    
    ;(load "4.38-44-distinct.scm") (install-distinct)
    
    (install-eight-queens)
    (driver-loop)
)
(test-4.44)