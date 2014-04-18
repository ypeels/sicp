(load "ch4-ambeval.scm")

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

