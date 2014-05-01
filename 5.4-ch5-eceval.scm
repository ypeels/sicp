;;;;EXPLICIT-CONTROL EVALUATOR FROM SECTION 5.4 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;; To use it
;;; -- load "load-eceval.scm", which loads this file and the
;;;    support it needs (including the register-machine simulator)

;;; -- To initialize and start the machine, do

;: (define the-global-environment (setup-environment))

;: (start eceval)

;; To restart, can do just
;: (start eceval)
;;;;;;;;;;


;;**NB. To [not] monitor stack operations, comment in/[out] the line after
;; print-result in the machine controller below
;;**Also choose the desired make-stack version in regsim.scm

(define eceval-operations                                           ; <==== 5.4: The Explicit-Control Evaluator
  (list
   ;;primitive Scheme operations
   (list 'read read)                                                ; Operations
                                                                        ; "To clarify the presentation... include as primitive[s]...
   ;;operations in syntax.scm                                           ; "the syntax procedures given in section 4.1.2...
   (list 'self-evaluating? self-evaluating?)
   (list 'quoted? quoted?)
   (list 'text-of-quotation text-of-quotation)
   (list 'variable? variable?)
   (list 'assignment? assignment?)
   (list 'assignment-variable assignment-variable)
   (list 'assignment-value assignment-value)
   (list 'definition? definition?)
   (list 'definition-variable definition-variable)
   (list 'definition-value definition-value)
   (list 'lambda? lambda?)
   (list 'lambda-parameters lambda-parameters)
   (list 'lambda-body lambda-body)
   (list 'if? if?)
   (list 'if-predicate if-predicate)
   (list 'if-consequent if-consequent)
   (list 'if-alternative if-alternative)
   (list 'begin? begin?)
   (list 'begin-actions begin-actions)
   (list 'last-exp? last-exp?)
   (list 'first-exp first-exp)
   (list 'rest-exps rest-exps)
   (list 'application? application?)
   (list 'operator operator)
   (list 'operands operands)
   (list 'no-operands? no-operands?)
   (list 'first-operand first-operand)
   (list 'rest-operands rest-operands)

   ;;operations in eceval-support.scm                                   ; "and the procedures for representing environments and other
   (list 'true? true?)                                                  ; "run-time data given in sections 4.1.3 and 4.1.4"
   (list 'make-procedure make-procedure)                                ; [i.e., a full "assembly-code" implementation would be thousands of lines long...]
   (list 'compound-procedure? compound-procedure?)
   (list 'procedure-parameters procedure-parameters)
   (list 'procedure-body procedure-body)
   (list 'procedure-environment procedure-environment)
   (list 'extend-environment extend-environment)
   (list 'lookup-variable-value lookup-variable-value)
   (list 'set-variable-value! set-variable-value!)
   (list 'define-variable! define-variable!)
   (list 'primitive-procedure? primitive-procedure?)
   (list 'apply-primitive-procedure apply-primitive-procedure)
   (list 'prompt-for-input prompt-for-input)
   (list 'announce-output announce-output)
   (list 'user-print user-print)
   (list 'empty-arglist empty-arglist)
   (list 'adjoin-arg adjoin-arg)
   (list 'last-operand? last-operand?)
   (list 'no-more-exps? no-more-exps?)	;for non-tail-recursive machine
   (list 'get-global-environment get-global-environment))
   )

(define eceval                                                      ; Registers
  (make-machine                                                         ; the eceval register machine includes a stack and 7 registers.
   '(expr env val proc argl continue unev)                              ; expr = expression to be evaluated; env = environment for evaluation
   eceval-operations                                                    ; val = value resulting from evaluating expr in env
  '(                                                                    ; continue is used to implement recursion (remember 5.1.4?) - to evaluate subexpressions
;;SECTION 5.4.4                                                         ; proc, argl, and unev are used in evaluating combinations.
read-eval-print-loop
  (perform (op initialize-stack))
  (perform
   (op prompt-for-input) (const ";;; EC-Eval input:"))
  (assign expr (op read))
  (assign env (op get-global-environment))
  (assign continue (label print-result))
  (goto (label eval-dispatch))
print-result
;;**following instruction optional -- if use it, need monitored stack
  (perform (op print-stack-statistics))
  (perform
   (op announce-output) (const ";;; EC-Eval value:"))
  (perform (op user-print) (reg val))
  (goto (label read-eval-print-loop))

unknown-expression-type
  (assign val (const unknown-expression-type-error))
  (goto (label signal-error))

unknown-procedure-type
  (restore continue)
  (assign val (const unknown-procedure-type-error))
  (goto (label signal-error))

signal-error
  (perform (op user-print) (reg val))
  (goto (label read-eval-print-loop))
                                                                    ; what follows is basically an ASSEMBLY PORT of mceval (selected portions)
;;SECTION 5.4.1                                                     ; <==== 5.4.1 The Core of the Explicit-Control Evaluator
eval-dispatch                                                           ; corresponds to (eval) in ch4-mceval.scm (p. 365)
  (test (op self-evaluating?) (reg expr))                                   ; evaluate:
  (branch (label ev-self-eval))                                             ; the expression specified by expr,
  (test (op variable?) (reg expr))                                          ; in the environment specified by env
  (branch (label ev-variable))                                              
  (test (op quoted?) (reg expr))                                            ; result: val = value of the expression,
  (branch (label ev-quoted))                                                ; and the controller will go to the entry point stored in continue
  (test (op assignment?) (reg expr))
  (branch (label ev-assignment))
  (test (op definition?) (reg expr))
  (branch (label ev-definition))
  (test (op if?) (reg expr))
  (branch (label ev-if))
  (test (op lambda?) (reg expr))
  (branch (label ev-lambda))
  (test (op begin?) (reg expr))
  (branch (label ev-begin))
  (test (op application?) (reg expr))
  (branch (label ev-application))
  (goto (label unknown-expression-type))                                ; Footnote 20 p. 549 - a Lisp ASIC (shudder) would implement 
                                                                            ; a more efficient (dispatch-on-type) assembly instruction
ev-self-eval                                                        ; Evaluating simple expressions: no subexpressions to be evaluated
  (assign val (reg expr))                                               ; simply place the correct value in the val register...
  (goto (reg continue))                                                 ; and continue execution at the entry point specified by continue
ev-variable                                                             ; cf. classification in 4.3.3 pp. 429ff
  (assign val (op lookup-variable-value) (reg expr) (reg env))
  (goto (reg continue))
ev-quoted
  (assign val (op text-of-quotation) (reg expr))
  (goto (reg continue))
ev-lambda
  (assign unev (op lambda-parameters) (reg expr))                       ; unev = parameters
  (assign expr (op lambda-body) (reg expr))                             ; expr = body (trashed the old contents)
  (assign val (op make-procedure)                                       ; (make-procedure parameters body env)
              (reg unev) (reg expr) (reg env))
  (goto (reg continue))

ev-application                                                      ; Evaluating procedure applications - the (application?) clause in (eval)
  (save continue)                                                       ; save continue for end of the eval-apply cycle
  (save env)                                                            ; save env for evaluating operands later
  (assign unev (op operands) (reg expr))                                ; parse operands and 
  (save unev)                                                           ; SAVE operands (expr is getting trashed, and maybe unev too)
  (assign expr (op operator) (reg expr))
  (assign continue (label ev-appl-did-operator))
  (goto (label eval-dispatch))                                          ; (eval operator env)
ev-appl-did-operator                                                        ; result: val = (eval operator env) = procedure to be applied to operands
  (restore unev)                                                            ; restore UNEValuated operands
  (restore env)                                                             ; restore env (reuse for operands)
  (assign argl (op empty-arglist))                                      ; (list-of-values operands env)
  (assign proc (reg val))                                                   ; proc = result of (eval operator), ready to apply
  (test (op no-operands?) (reg unev))                                       ; if there are no operands,
  (branch (label apply-dispatch))                                           ; then apply the procedure directly
  (save proc)                                                               ; otherwise, save proc (getting trashed?)
ev-appl-operand-loop                                                        ; iterations of (list-of-values)
  (save argl)                                                                   ; save the arguments accumulated so far
  (assign expr (op first-operand) (reg unev))                                   ; expr = next operand
  (test (op last-operand?) (reg unev))                                              ; (first-operand) and (rest-operands) determine left-to-right evaluation order (cf. Exercises 3.8, 4.1)
  (branch (label ev-appl-last-arg))                                             ; last operand is handled as a special case
  (save env)
  (save unev)                                                                   ; save the remaining operands to be evaluated
  (assign continue (label ev-appl-accumulate-arg))
  (goto (label eval-dispatch))                                                  ; (eval next-operand env)
ev-appl-accumulate-arg                                                              ; result: val = (eval next-operand env)
  (restore unev)
  (restore env)                                                                     ; paranoid or necessary? who knows...
  (restore argl)
  (assign argl (op adjoin-arg) (reg val) (reg argl))                                ; accumulate operand value into running list
  (assign unev (op rest-operands) (reg unev))                                       ; remove from list of unevaluated operands
  (goto (label ev-appl-operand-loop))                                               ; done with this iteration!
ev-appl-last-arg                                                            ; final iteration of (list-of-values) - Footnote 23 - evlis tail recursion optimization   
  (assign continue (label ev-appl-accum-last-arg))                              ; no need to save env or unev - unneeded after evaluating the last operand
  (goto (label eval-dispatch))                                                  ; (eval last-operand env)
ev-appl-accum-last-arg                                                              ; result: val = (eval last-operand env)
  (restore argl)                                                                    ; in case it was trashed by eval?    
  (assign argl (op adjoin-arg) (reg val) (reg argl))                                ; accumulate result to complete ARGument List
  (restore proc)                                                                    ; restore proc = operator from ev-appl-did-operator
  (goto (label apply-dispatch))                                             ; (apply proc=operator argl=operands) finally
apply-dispatch                                                                  ; primitive and compound cases, 
  (test (op primitive-procedure?) (reg proc))                                   ; just like (apply) in mceval [well, it's not a coincidence... this IS just an asm translation of PARTS of mceval...]
  (branch (label primitive-apply))
  (test (op compound-procedure?) (reg proc))  
  (branch (label compound-apply))
  (goto (label unknown-procedure-type))

primitive-apply                                                                 ; val = (apply-primitive-procedure
  (assign val (op apply-primitive-procedure)                                        ; proc=operator argl=arguments)
              (reg proc)                                                            ; punts to apply-in-underlying-scheme
              (reg argl))
  (restore continue)                                                            ; saved all the way back at ev-application
  (goto (reg continue))                                                         ; return val; done with current eval-apply cycle! (of course, MIGHT have been nested from a compound procedure...)

compound-apply                                                                  ; [text is a little too descriptive - it's the (extend-environment) "primitive" that's gonna create a new frame, etc.]
  (assign unev (op procedure-parameters) (reg proc))                            ; unev = (parameters proc) [trash register]
  (assign env (op procedure-environment) (reg proc))                            ; env = current environment
  (assign env (op extend-environment)                                           ; env = (extend-environment unev=params argl=values env)
              (reg unev) (reg argl) (reg env))                                      ; <===== the only place where env is ever assigned a new value
  (assign unev (op procedure-body) (reg proc))                                  ; unev = (body proc)
  (goto (label ev-sequence))                                                    ; val = (eval-sequence unev env)

;;;SECTION 5.4.2                                                    ; <==== 5.4.2: Sequence Evaluation and Tail Recursion
ev-begin
  (assign unev (op begin-actions) (reg expr))                           ; unev = sequence of expressions to be evaluated
  (save continue)
  (goto (label ev-sequence))

ev-sequence                                                             ; (eval-sequence unev=exps env) - loop over unev
  (assign expr (op first-exp) (reg unev))
  (test (op last-exp?) (reg unev))                                          ; if there additional expressions...
  (branch (label ev-sequence-last-exp))
  (save unev)                                                               ; process them later...
  (save env)
  (assign continue (label ev-sequence-continue))
  (goto (label eval-dispatch))                                              ; (eval expr=first-exp env)
ev-sequence-continue                                                            ; result (unused?): val = value of first-exp 
  (restore env)
  (restore unev)
  (assign unev (op rest-exps) (reg unev))                                   ; get next expression (could have done this in ev-sequence)
  (goto (label ev-sequence))                                                ; next loop iteration
ev-sequence-last-exp                                                        ; last loop iteration - unev and env unneeded after this
  (restore continue)                                                            ; end of (eval-sequence), so return after (eval)
  (goto (label eval-dispatch))                                                  ; (eval expr=last-exp env)

;;;SECTION 5.4.3

ev-if
  (save expr)
  (save env)
  (save continue)
  (assign continue (label ev-if-decide))
  (assign expr (op if-predicate) (reg expr))
  (goto (label eval-dispatch))
ev-if-decide
  (restore continue)
  (restore env)
  (restore expr)
  (test (op true?) (reg val))
  (branch (label ev-if-consequent))
ev-if-alternative
  (assign expr (op if-alternative) (reg expr))
  (goto (label eval-dispatch))
ev-if-consequent
  (assign expr (op if-consequent) (reg expr))
  (goto (label eval-dispatch))

ev-assignment
  (assign unev (op assignment-variable) (reg expr))
  (save unev)
  (assign expr (op assignment-value) (reg expr))
  (save env)
  (save continue)
  (assign continue (label ev-assignment-1))
  (goto (label eval-dispatch))
ev-assignment-1
  (restore continue)
  (restore env)
  (restore unev)
  (perform
   (op set-variable-value!) (reg unev) (reg val) (reg env))
  (assign val (const ok))
  (goto (reg continue))

ev-definition
  (assign unev (op definition-variable) (reg expr))
  (save unev)
  (assign expr (op definition-value) (reg expr))
  (save env)
  (save continue)
  (assign continue (label ev-definition-1))
  (goto (label eval-dispatch))
ev-definition-1
  (restore continue)
  (restore env)
  (restore unev)
  (perform
   (op define-variable!) (reg unev) (reg val) (reg env))
  (assign val (const ok))
  (goto (reg continue))
   )))

'(EXPLICIT CONTROL EVALUATOR LOADED)
