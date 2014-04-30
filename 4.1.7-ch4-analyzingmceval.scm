;;;;METACIRCULAR EVALUATOR THAT SEPARATES ANALYSIS FROM EXECUTION
;;;; FROM SECTION 4.1.7 OF STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch4.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;**NOTE**This file loads the metacircular evaluator of
;;;;  sections 4.1.1-4.1.4, since it uses the expression representation,
;;;;  environment representation, etc.
;;;;  You may need to change the (load ...) expression to work in your
;;;;  version of Scheme.
;;;;**WARNING: Don't load mceval twice (or you'll lose the primitives
;;;;  interface, due to renamings of apply).

;;;;Then you can initialize and start the evaluator by evaluating
;;;; the two lines at the end of the file ch4-mceval.scm
;;;; (setting up the global environment and starting the driver loop).


;;**implementation-dependent loading of evaluator file
;;Note: It is loaded first so that the section 4.1.7 definition
;; of eval overrides the definition from 4.1.1
(load "ch4-mceval.scm")

;;;SECTION 4.1.7

(define (eval expr env)
  ((analyze expr) env))

(define (analyze expr)
  (cond ((self-evaluating? expr) 
         (analyze-self-evaluating expr))
        ((quoted? expr) (analyze-quoted expr))
        ((variable? expr) (analyze-variable expr))
        ((assignment? expr) (analyze-assignment expr))
        ((definition? expr) (analyze-definition expr))
        ((if? expr) (analyze-if expr))
        ((lambda? expr) (analyze-lambda expr))
        ((begin? expr) (analyze-sequence (begin-actions expr)))
        ((cond? expr) (analyze (cond->if expr)))
        
        ; Exercise 4.22 - will use Exercise 4.6 code in ch4-mceval.scm.
        ; this is IT! behold the power of derived expressions
        ((let? expr) (analyze (let->combination expr)))
        
        ((application? expr) (analyze-application expr))
        (else
         (error "Unknown expression type -- ANALYZE" expr))))

(define (analyze-self-evaluating expr)
  (lambda (env) expr))

(define (analyze-quoted expr)
  (let ((qval (text-of-quotation expr)))
    (lambda (env) qval)))

(define (analyze-variable expr)
  (lambda (env) (lookup-variable-value expr env)))

(define (analyze-assignment expr)
  (let ((var (assignment-variable expr))
        (vproc (analyze (assignment-value expr))))
    (lambda (env)
      (set-variable-value! var (vproc env) env)
      'ok)))

(define (analyze-definition expr)
  (let ((var (definition-variable expr))
        (vproc (analyze (definition-value expr))))
    (lambda (env)
      (define-variable! var (vproc env) env)
      'ok)))

(define (analyze-if expr)
  (let ((pproc (analyze (if-predicate expr)))
        (cproc (analyze (if-consequent expr)))
        (aproc (analyze (if-alternative expr))))
    (lambda (env)
      (if (true? (pproc env))
          (cproc env)
          (aproc env)))))

(define (analyze-lambda expr)
  (let ((vars (lambda-parameters expr))
        (bproc (analyze-sequence (lambda-body expr))))
    (lambda (env) (make-procedure vars bproc env))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

(define (analyze-application expr)
  (let ((fproc (analyze (operator expr)))
        (aprocs (map analyze (operands expr))))
    (lambda (env)
      (execute-application (fproc env)
                           (map (lambda (aproc) (aproc env))
                                aprocs)))))

(define (execute-application proc args)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure proc args))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment (procedure-parameters proc)
                              args
                              (procedure-environment proc))))
        (else
         (error
          "Unknown procedure type -- EXECUTE-APPLICATION"
          proc))))

'ANALYZING-METACIRCULAR-EVALUATOR-LOADED
