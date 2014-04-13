; like Louis, I am BAFFLED by this problem

; after thinking for some time, my only idea was that maybe system (map) uses system (apply)!?
    ; after all, overwriting the system's (apply) [and (eval)?] is the only significant change
    ; our toy metacircular evaluator makes to the underlying Scheme?
    
(define apply 'apply)
(define eval 'eval)
(newline) (display (map square '(1 2 3)))     ; (1 4 9)
    ; no, this STILL WORKS...


; well, here's the definition of map from ch2.scm...
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))
    ; confirmed that typing this into running ch4-mceval.scm and then using it DOES work...
            
; well, null, cons, car, map are all primitives available in the "guest" evaluator



            
; i really have to say, i do NOT see how louis went wrong here...
(define primitive-procedures
  (list (list 'car car)
        ; ...
        (list 'map map)     ; this is what louis did, right?
        ;...
        ))
; here's the result of 
    ; The object (primitive #[compiled-procedure 11 ("arith" #x110) #xf #x210e0cb]) is not applicable.
    
; LOOKS like map is too high-level ("not primitive enough") and can't be exposed to the user?


; ok, how about typing the following into M-Eval:
(map (lambda (x) x) '(1 2 3))
;The object (procedure (x) (x) (((false true car cdr cons null? map) .... ))) is not applicable
    ; ok, looks like the problem is that system map has NO idea how to eval our custom data structures
        ; you know, how M-Eval's (eval) takes the lambda and bundles it up as a "tagged-list"?
    ; you also can't break system map by redefining apply or eval.
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; to be eligible for addition to the table primitive-procedures, the following must work in M-Eval's (apply):
    (apply-primitive-procedure procedure arguments)
    
; but that's defined as
(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))
   
; and of course
(define apply-in-underlying-scheme apply)
(define (primitive-implementation proc) (cadr proc))

; so, we know the basic infrastructure is working, so (primitive-implementation proc) evaluates to
    map
    
; and so (apply-primitive-procedure map arguments) evaluates to
    (apply map arguments)
    
    (lambda (x) x) ; evaluates to (pp. 365, 377) ('procedure (x) (x)
    
; even if you installed square as a primitive and tried
    (map square '(1 2 3))
    ; M-Eval's lookup-variable would return the corresponding entry in (primitive-procedure-objects)
        ; namely (p. 382) ('primitive square)
        
; looks like any higher-order functions CANNOT be primitives??
    
; so the problem is that our custom eval slaps metadata onto the arguments as they are.
; not really sure why the entire primitive-procedure table got tacked on...
; but at least this explains why louis' addition to the primitive-procedures table doesn't work.

; M-Eval's (eval) 


; so what makes a primitive primitive??
    ; basically, whether its arguments are ultimately self-evaluating?
    
; also, how does alyssa's map work?
    ; oh it goes through the (compound-procedure?) branch of M-Eval's (apply)
    ; this will parse everything down to the level where arguments and procedures are BOTH primitive...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; exploring the outstanding mystery further
    ; add display to list of primitives and run the following in M-Eval:
    (display (lambda (x) x))
        ; (procedure (x) (x) (((false true car cdr cons null? map) #f #t (primitive #[compiled-procedure]...
        ; OH, pp. 365, 377
        ; M-Eval calls (make-procedure) on the lambda
        ; (make-procedure) returns (list 'procedure parameters body env)
            ; M-Eval is printing THE ENTIRE ENVIRONMENT. mystery solved.
            ; that's the whole reason they introduced (user-print) on p. 383... had to rediscover that for myself...



