;;;;AMB EVALUATOR FROM SECTION 4.3 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch4.scm.
;;;; To run the sample programs and exercises, code below also includes
;;;; -- enlarged primitive-procedures list
;;;; -- support for Let (as noted in footnote 56, p.428)

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
;;;;In the driver loop, do
;(define (require p)
;  (if (not p) (amb)))


;;**implementation-dependent loading of evaluator file
;;Note: It is loaded first so that the section 4.2 definition
;; of eval overrides the definition from 4.1.1
(load "ch4-mceval.scm")



;;;Code from SECTION 4.3.3, modified as needed to run it

(define (amb? expr) (tagged-list? expr 'amb))
(define (amb-choices expr) (cdr expr))

;; analyze from 4.1.6, with clause from 4.3.3 added                                 ; "modifying the analyzing evaluator of section 4.1.7"
;; and also support for Let
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
        ((let? expr) (analyze (let->combination expr))) ;**                         ; Footnote 56: text added (let) derived expression from Exercise 4.22
        ((amb? expr) (analyze-amb expr))                ;**                         ; <======= the new special form
        ((application? expr) (analyze-application expr))
        (else
         (error "Unknown expression type -- ANALYZE" expr))))

(define (ambeval expr env succeed fail)                                             ; new replacement for (eval) in (driver-loop) - no need to override (eval)
  ((analyze expr) env succeed fail))                                                ; succeed, fail = new continuation args (p. 429)

;;;Simple expressions                                                               ; <-- "essentially the same": simply succeed with value, passing along the failure continuation from input argument

(define (analyze-self-evaluating expr)                                                  ; each lambda is the resulting EXECUTION PROCEDURE - applied in (ambeval).
  (lambda (env succeed fail)                                                            ; previously (lambda (env) expr)
    (succeed expr fail)))

(define (analyze-quoted expr)
  (let ((qval (text-of-quotation expr)))
    (lambda (env succeed fail)                                                          ; previously (lambda (env) qval)
      (succeed qval fail))))

(define (analyze-variable expr)
  (lambda (env succeed fail)                                                            ; previously (lambda (env) (lookup-variable-value expr env))
    (succeed (lookup-variable-value expr env)                                           ; (lookup) will correctly abort with (error) if var is unbound - this is a bug, not an amb choice
             fail)))

(define (analyze-lambda expr)
  (let ((vars (lambda-parameters expr))
        (bproc (analyze-sequence (lambda-body expr))))
    (lambda (env succeed fail)                                                          ; previously (lambda (env) (make-procedure vars bproc env))
      (succeed (make-procedure vars bproc env)
               fail))))

;;;Conditionals and sequences                                                       ; <-- "handled in a similar way": 

(define (analyze-if expr)
  (let ((pproc (analyze (if-predicate expr)))
        (cproc (analyze (if-consequent expr)))
        (aproc (analyze (if-alternative expr))))
    (lambda (env succeed fail)                                                          
      (pproc env                                                                        ; first TRY the predicate - it might fail!
             ;; success continuation for evaluating the predicate
             ;; to obtain pred-value
             (lambda (pred-value fail2)                                                 ; p. 429: succeed continuation is (lambda (value fail)...)
               (if (true? pred-value)                                                   ; 4.1.7: the (if) is evaluated directly.
                   (cproc env succeed fail2)
                   (aproc env succeed fail2)))
             ;; failure continuation for evaluating the predicate
             fail))))

(define (analyze-sequence exps)
  (define (sequentially a b)                                                            
    (lambda (env succeed fail)                                                          ; previously (lambda (env) (proc1 env) (proc2 env))
      (a env
         ;; success continuation for calling a                                          ; new "machinations...required for passing the continuations"    
         (lambda (a-value fail2)
           (b env succeed fail2))                                                       ; only call b when a succeeds.
         ;; failure continuation for calling a
         fail)))
  (define (loop first-proc rest-procs)                                                  ; unchanged!
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))                                                     ; unchanged!
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

;;;Definitions and assignments

(define (analyze-definition expr)                                                   ; <-- "some trouble to manage the continuations" (find value first)
  (let ((var (definition-variable expr))
        (vproc (analyze (definition-value expr))))
    (lambda (env succeed fail)                                                          ; previously (lambda (env) (define-variable! var (vproc env) env) 'ok)
      (vproc env                                                                        ; TRY to obtain definition's value
             (lambda (val fail2)                                                        ; success continuation (def's value): define!
               (define-variable! var val env)
               (succeed 'ok fail2))                                                     ; Footnote 57: "We didn't worry about undoing definitions, since we can assume that internal definitions are scanned out (section 4.1.6)."
             fail))))                                                                   ; i think this is because (amb) only branches WITHIN PROCEDURES?
                                                                                        ; also, they probably didn't want to worry about completely erasing a (first) definition
(define (analyze-assignment expr)                                                   ; <-- "the first place where we really use the continuations, rather than just passing them around."
  (let ((var (assignment-variable expr))
        (vproc (analyze (assignment-value expr))))
    (lambda (env succeed fail)                                                          ; previously (lambda (env) (set-variable-value! var (vproc env) env) 'ok)
      (vproc env                                                                        ; TRY to obtain assignment's value, like (analyze-definition)
             (lambda (val fail2)        ; *1*                                           ; success continuation (set's value)
               (let ((old-value                                                             ; save old value in case this branch later fails - and you need to backtrack
                      (lookup-variable-value var env))) 
                 (set-variable-value! var val env)
                 (succeed 'ok
                          (lambda ()    ; *2*                                               ; successful assignment provides a failure continuation that will intercept a subsequent failure
                            (set-variable-value! var
                                                 old-value
                                                 env)
                            (fail2)))))                                                     ; and don't forget to continue popping the failure stack
             fail))))                                                                   
                                                                                        
;;;Procedure applications

(define (analyze-application expr)
  (let ((fproc (analyze (operator expr)))
        (aprocs (map analyze (operands expr))))
    (lambda (env succeed fail)
      (fproc env
             (lambda (proc fail2)
               (get-args aprocs
                         env
                         (lambda (args fail3)
                           (execute-application
                            proc args succeed fail3))
                         fail2))
             fail))))

(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs) env
                    ;; success continuation for this aproc
                    (lambda (arg fail2)
                      (get-args (cdr aprocs)
                                env
                                ;; success continuation for recursive
                                ;; call to get-args
                                (lambda (args fail3)
                                  (succeed (cons arg args)
                                           fail3))
                                fail2))
                    fail)))

(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? proc)
         (succeed (apply-primitive-procedure proc args)
                  fail))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment (procedure-parameters proc)
                              args
                              (procedure-environment proc))
          succeed
          fail))
        (else
         (error
          "Unknown procedure type -- EXECUTE-APPLICATION"
          proc))))

;;;amb expressions

(define (analyze-amb expr)
  (let ((cprocs (map analyze (amb-choices expr))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
            (fail)
            ((car choices) env
                           succeed
                           (lambda ()
                             (try-next (cdr choices))))))
      (try-next cprocs))))

;;;Driver loop

(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
          (try-again)
          (begin
            (newline)
            (display ";;; Starting a new problem ")
            (ambeval input
                     the-global-environment
                     ;; ambeval success
                     (lambda (val next-alternative)
                       (announce-output output-prompt)
                       (user-print val)
                       (internal-loop next-alternative))
                     ;; ambeval failure
                     (lambda ()
                       (announce-output
                        ";;; There are no more values of")
                       (user-print input)
                       (driver-loop)))))))
  (internal-loop
   (lambda ()
     (newline)
     (display ";;; There is no current problem")
     (driver-loop))))

; convenience function - based on (driver-loop)
(define (ambeval-batch . input-list)

    (define (ambeval-single-input input)
        (display "\n;;; Input from batch file\n")
        (display input)
        (newline)
        (ambeval 
            input 
            the-global-environment
            (lambda (val next)
                (announce-output output-prompt)
                (user-print val)
                (newline))   ; do not loop.
            (lambda ()
                (announce-output "Failure executing -- AMBEVAL-BATCH")
                (newline))
        )
    )
    
    (for-each ambeval-single-input input-list)
)
            
        
     


;;; Support for Let (as noted in footnote 56, p.428)

(define (let? expr) (tagged-list? expr 'let))
(define (let-bindings expr) (cadr expr))
(define (let-body expr) (cddr expr))

(define (let-var binding) (car binding))
(define (let-val binding) (cadr binding))

(define (make-combination operator operands) (cons operator operands))

(define (let->combination expr)
  ;;make-combination defined in earlier exercise
  (let ((bindings (let-bindings expr)))
    (make-combination (make-lambda (map let-var bindings)
                                   (let-body expr))
                      (map let-val bindings))))
                     


;; A longer list of primitives -- suitable for running everything in 4.3
;; Overrides the list in ch4-mceval.scm
;; Has Not to support Require; various stuff for code in text (including
;;  support for Prime?); integer? and sqrt for exercise code;
;;  eq? for ex. solution

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'list list)
        (list 'memq memq)
        (list 'member member)
        (list 'not not)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '= =)
        (list '> >)
        (list '>= >=)
        (list 'abs abs)
        (list 'remainder remainder)
        (list 'integer? integer?)
        (list 'sqrt sqrt)
        (list 'eq? eq?)
;;      more primitives

        ; for Exercise 4.36
        (list 'display display)
        
        ; for Exercise 4.44
        (list '<= <=)
        (list 'length length)
        (list 'list-ref list-ref)
        (list 'newline newline)
        (list 'append append)
        ))

(define the-global-environment (setup-environment))
        
'AMB-EVALUATOR-LOADED
