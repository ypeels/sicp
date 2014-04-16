; a little late in the book to be introducing new characters, isn't it? no matter...

(load "4.27-31-ch4-leval.scm")


; (append! primitive-procedures (list (list 'for-each for-each))) ; nope - remember 4.14?
;(define the-global-environment (setup-environment))

(display "
a.
(define (for-each proc items) (if (null? items) 'done (begin (proc (car items)) (for-each proc (cdr items)))))
(for-each (lambda (x) (newline) (display x)) '(57 321 88))
")
; 57
; 321
; 88
; done
; indeed, as ben says, all those lines get executed.
; that is, (eval ((lambda (x)...) 57)) does wind up calling all the lines inside
    ; the sequence of (newline) (display x) gets forced because it's in the OPERATOR? (cf. 4.28)
        ; well, the sequence in p1 below is getting executed too... because it's a BODY, and not an ARGUMENT??
            ; the lambda IS getting passed as an argument to the for-each, but then it's being applied
                ; so everything will be evaluated through, except maybe ITS arguments?
                    ; that would explain p2 - an UNEVALUATED ARGUMENT that also happens to have a side effect.
    ; sol: also, display is a PRIMITIVE
        ; no... (display x) is the FINAL statement... it's that (newline) is a primitive!?
            ; eventually you'll get down to (eval newline), and that'll call the primitive instead of making it a thunk?
    
    
(display "
b. 
(define (p1 x) (set! x (cons x '(2))) x)
(define (p2 x) (define (p e) e x) (p (set! x (cons x '(2)))))
(p1 1)
(p2 1)
")
(define (eval-sequence-4.30b exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (actual-value (first-exp exps) env)
              (eval-sequence-4.30b (rest-exps exps) env))))

; unmodified leval
; (p1 1) = (1 2) 
; (p2 1) = 1
    ; the p2 case is exactly what cy was worried about...
    ; uh, what's going on here, exactly??
        ; p1: x = #thunk (cons x '(2)), and user forces evaluation?
        ; p2: (p2 1) = ( (lambda (e) e x) (set! x (cons x '(2))) )
        ; in p2, the UNAPPLIED operator doesn't contain the (set!)
        ; then, applying the lambda, you're left with a sequence, whose members are LAZILY evaluated
        ; nobody ever uses the value of e, so its side effect never gets executed. 
            ; that's my story, and i'm sticking to it
        
    
; with cy's change              
;(define eval-sequence eval-sequence-4.30b)
; (p1 1) = (1 2)
; (p2 1) = (1 2)


; c. 
; empirically, the result from a. is unaffected by cy's change.
; i think this is because as an operator, the sequence in the lambda was already getting forced.
; there were also no pathological expressions being ignored lazily, and no assignments to worry about.


; d.
; cy's approach is too drastic, since "pro-active" (eval-sequence) would affect ALL compound procedures (via apply)
; lazy is as lazy does... the approach in the book seems good enough to me
    ; aren't side effects + lazy evaluation tricky to begin with??
; MAYBE the approach in 4.31 is preferable, where you can specify arguments as non-lazy? 


    
(driver-loop)
