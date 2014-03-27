; from problem statement
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

(load "2.40-43-flatmap.scm")    ; for flatmap. enumerate-interval is there too!


; I think we did this in CS 1...or at the very least, I've seen Figure 2.8 before...


; need to write
; empty-board
; safe? - parses the data structure to see if any queens check each other
; adjoin-position - defines the data structure


(define empty-board ())

; my queen data structure. could also use (list row col). does it make a difference??
(define (make-queen row col) 
    (cons row col))
(define (row-queen q) 
    (car q))
(define (col-queen q) 
    (cdr q))

; a board is just a list of queens.
(define (adjoin-position row col board)
    (append board (list (make-queen row col))))
    
; extract the kth queen from the board
(define (queen-board j board)
    (if (and (<= 1 j) (<= j (length board)))
        (list-ref board (- j 1))
        (error "queen-board out of range" j (length board))))
        
(define (safe? k board)
    #f
)





; testing code. gotta have board output...
(define (display-board board)

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
                "unused return value")
        )
    )

    
    (display "---------------\n")
    (iter 1)
)
    
    
    
(define (test-2.42)
    (define (test n)        
        (for-each  
            display-board
            (queens n)
        )
    )
    
    ;(test 2)
    (test 3)
    (display "\nthat's all, folks!")
)


(test-2.42)