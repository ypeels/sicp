(load "ch4-ambeval.scm")

(define (install-element-of)
    (ambeval-batch
        ; wow, really haven't needed before!?
        '(define (an-element-of items)
          (require (not (null? items)))
          (amb (car items) (an-element-of (cdr items))))
    )   
)

(define analyze-ambeval analyze)
(define (analyze-4.51 expr)
    (if (permanent-assignment? expr)
        (analyze-permanent-assignment expr)
        (analyze-ambeval expr)
    )
)

(define (permanent-assignment? expr) (tagged-list? expr 'permanent-set!))


; this just mirrors (analyze-definition), without the backtracking apparatus of (analyze-assignment)
(define (analyze-permanent-assignment expr)
  (let ((var (assignment-variable expr))            ; assuming same syntax as (set!) 
        (vproc (analyze (assignment-value expr))))  ; note that (defintion-variable) would allow functions...
    (lambda (env succeed fail)
      (vproc env              
             (lambda (val fail2)
               (set-variable-value! var val env)    ; <-- instead of (define-variable!)
               (succeed 'ok fail2))             
             fail)))) 
             
;(define analyze analyze-4.51) ; hmmmmmmm...


; i GUESS make it cumulative... keeping this in the same file as 4.51 ensures correct "load order"
(define (analyze-4.52 expr)
    (if (if-fail? expr)
        (analyze-if-fail expr)
        (analyze-4.51 expr)
    )
)

(define (if-fail? expr) (tagged-list? expr 'if-fail))
(define (if-fail-good expr) (cadr expr)) ; naming these if-fail-success and if-fail-failure is too confusing
(define (if-fail-bad expr) (caddr expr))


; If-fail takes two expressions. 
; It evaluates the first expression as usual and returns as usual if the evaluation succeeds. 
; If the evaluation fails, however, the value of the second expression is returned
(define (analyze-if-fail expr)
    (let (  (goodproc (analyze (if-fail-good expr)))
            (badproc (analyze (if-fail-bad expr)))
            )
            
        
        
        (lambda (env succeed fail)
            (goodproc                       ; required? i think you can't (succeed) this unconditionally...
                env                
                
                ;(lambda (goodval fail2) goodval); this didn't return ANY value!
                (lambda (goodval fail2) (succeed goodval fail2))
                
                ; and if goodproc should FAIL...
                (lambda () (badproc env succeed fail))  ; are these the right arguments?? meh tests pass...
            )
        )
    )
)
                
                
                    
        
    
