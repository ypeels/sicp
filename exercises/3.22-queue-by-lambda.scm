; 3.22-queue-by-lambda.scm
; so named as a reference to cons-by-lambda...
; i mean, procedures are "named lambdas"...


; this has more in common with make-account than with the (cons) implementation before exercise 3.20

; here is example usage
; (define q (make-queue)) 	
; (insert-queue! q 'a) 	a
; (insert-queue! q 'b) 	a b
; (delete-queue! q) 	b
; (insert-queue! q 'c) 	b c
; (insert-queue! q 'd) 	b c d
; (delete-queue! q) 	c d
; 
; and maybe also want 
; (front-queue
    ; (pop-queue? external convenience function?
; (empty-queue?
; basically, more practice with modifiers and internal state; combining them for the first time?


; skeleton from problem statement
(define (make-queue)
  (let ((front-ptr '());...)
        (rear-ptr '()));...))
        
    ;<definitions of internal procedures>
    (define (empty?)
        (null? front-ptr)) ;(null? rear-ptr)))          ; if you want to also double-check rear-ptr, you also have to set it to null in delete!
    (define (print)
        (display front-ptr))
    (define (insert! new-item)
        (let ((new-pair (cons new-item '())))        
            (if (empty?)
                (begin
                    (set! front-ptr new-pair)           ; n.b. internal data members increase temptation not to use mutator PROCEDURES
                    (set! rear-ptr new-pair)
                )
                (begin
                    (set-cdr! rear-ptr new-pair)
                    (set! rear-ptr new-pair)
                    ; front unchanged
                )
            )
            front-ptr
        )
    )
    (define (delete!)                                   ; n.b. (delete!) is also a built-in!
        ; i GUESS i can not care about rear-ptr - saves one comparison (last item in queue)
        
        (if (empty?)
            (begin (error "Empty queue -- DELETE! -- MAKE-QUEUE")  'asdf)
            (begin
                (set! front-ptr (cdr front-ptr)) 
                front-ptr
            )
        )
    )   
    (define (front)
        (car front-ptr))
    
    (define (dispatch m) ;...)
        (cond 
            ((eq? m 'insert!)
                insert!)            ; the only one that takes an argument
            ((eq? m 'delete!)
                (delete!))
            ((eq? m 'empty?)
                (empty?))
            ((eq? m 'print)
                (print)
                'unused-return-value)
            ((eq? m 'front)
                (front))
            (else
                (error "Undefined operation -- MAKE-QUEUE" M))
        )
    )
    
    
    dispatch))
    
(define (insert-queue! q item)
    ((q 'insert!) item))
(define (delete-queue! q)
    (q 'delete!))    
;(define (empty-queue? q)
;    (q 'empty?))
(define (print-queue q)
    (q 'print))
;(define (front-queue q)     ; otherwise it's a pretty useless "write-only" data structure
;    (q 'front))
    
    
; testing
(define (test-3.22)
    (let ((q (make-queue)))
        (newline)
        (insert-queue! q 'a) (print-queue q) (newline) ; a
        (insert-queue! q 'b) (print-queue q) (newline) ; a b
        (delete-queue! q)    (print-queue q) (newline) ; b
        (insert-queue! q 'c) (print-queue q) (newline) ; b c
        (insert-queue! q 'd) (print-queue q) (newline) ; b c d
        (delete-queue! q)    (print-queue q) (newline) ; c d
        (delete-queue! q)    (print-queue q) (newline) ; d
        (delete-queue! q)    (print-queue q) (newline) ; ()
        ;(delete-queue! q)    (print-queue q) (newline) ; Empty queue -- DELETE! -- MAKE-QUEUE
    )
)
(test-3.22)