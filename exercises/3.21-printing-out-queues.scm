; scheme knows how to print pairs and lists, and that's it
; queue = (front-ptr . rear-ptr)
; so (display queue) will print: ( (queue contents) final item )
; and moreover, since delete-queue! was LAZY and only deleted front-ptr,
; (display (delete-queue! queue)) will print: ( '() final item )

; my oh my, Ben Bitdiddle is getting in over his head...

; from ch3.scm
;;;SECTION 3.3.2

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue)))) 

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue))) 
         
; my addition
(define (print-queue q)
    (display (front-ptr q)))
    
(define (test-3.21)
    (let ((q1 (make-queue)))
        (insert-queue! q1 'a)   (print-queue q1) (newline)  ; (a)
        (insert-queue! q1 'b)   (print-queue q1) (newline)  ; (a b)
        (delete-queue! q1)      (print-queue q1) (newline)  ; (b)
        (delete-queue! q1)      (print-queue q1) (newline)  ; ()
    )
)
;(test-3.21)