;;;;EXPLICIT-CONTROL EVALUATOR FROM SECTION 5.4 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS
;;;; MODIFIED TO SUPPORT COMPILED CODE (AS IN SECTION 5.5.7)

;;;;Changes to basic evaluator machine are
;;;; (1) some new eceval controller code for the driver and apply-dispatch;
;;;; (2) some additional machine operations from;
;;;; (3) support for compiled code to call interpreted code (exercise 5.47) --
;;;;     (new register and 1 new instruction at start)
;;;; (4) new startup aid start-eceval

;; exprlicit-control evaluator.
;; To use it, load "load-eceval-compiler.scm", which loads this file and the
;;  support it needs (including the register-machine simulator)

;; To start, can use compile-and-go as in section 5.5.7
;;  or start-eceval as in the section 5.5.7 footnote.

;; To resume the machine without reinitializing the global environment
;; if you have somehow interrupted out of the machine back to Scheme, do

;: (set-register-contents! eceval 'flag false)
;: (start eceval)

;;;;;;;;

;; any old value to create the variable so that
;;  compile-and-go and/or start-eceval can set! it.
(define the-global-environment '())                                     ; new! for once, we don't have to do this ourselves

;;; Interfacing compiled code with eceval machine
;;; From section 5.5.7                                                  ; new! from Footnote 49 p. 605 [previously (define the-global-env) (start eceval)]
(define (start-eceval)                                                      ; this procedure does NOT compile/execute external code.
  (set! the-global-environment (setup-environment))                             ; "backwards compatibility" - should behave same as ch5-eceval.scm
  (set-register-contents! eceval 'flag false)                               ; <--- key difference: must initialize flag register before starting
  (start eceval))                                                           ; previously: (define the-global-env) (start eceval), DIY

;; Modification of section 4.1.4 procedure
;; **replaces version in syntax file                                    ; actually, replaces version in ch5-eceval-support.scm
(define (user-print object)                                             ; changed! Footnote 50 p. 605
  (cond ((compound-procedure? object)
         (display (list 'compound-procedure
                        (procedure-parameters object)
                        (procedure-body object)
                        '<procedure-env>)))
        ((compiled-procedure? object)                                       ; 1 new case so it won't print compiled procedures either
         (display '<compiled-procedure>))
        (else (display object))))

(define (compile-and-go expression . other-args)                        ; new! 5.5.7 p. 606
  (let ((instructions
         (assemble (statements                                              ; assemble object code to executable (regsim) code
                    ;(compile expression 'val 'return))
                    (apply compile (append                                  ; compile Scheme code to object (assembly) code
                        (list expression 'val 'return)                      ; val/return linkage matches assumptions from external-entry below
                        other-args)))
                   eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)                       ; val=expression code, eceval.the-instruction-sequence = interpreter
    (set-register-contents! eceval 'flag true)                              ; evaluator will go to external-entry and execute val - Footnote 49 p. 605
    (start eceval)))                                                            ; then it will print results and enter the EC-Eval main loop.

;;**NB. To [not] monitor stack operations, comment in/[out] the line after
;; print-result in the machine controller below
;;**Also choose the desired make-stack version in regsim.scm

(define eceval-operations
  (list
   ;;primitive Scheme operations
   (list 'read read)			;used by eceval

   ;;used by compiled code                                              ; new, but not mentioned in book    
   (list 'list list)                                                        ; used by (construct-arglist) in ch5-compiler.scm
   (list 'cons cons)                                                        ; used by (code-to-get-rest-args) in ch5-compiler.scm

   ;;operations in syntax.scm
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

   ;;operations in eceval-support.scm
   (list 'true? true?)
   (list 'false? false?)		;for compiled code                      ; new! used by (compile-if) in ch5-compiler.scm    
   (list 'make-procedure make-procedure)
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
   (list 'get-global-environment get-global-environment)

   ;;for compiled code (also in eceval-support.scm)                     ; new! 5.5.3 Footnote 38 p. 580
   (list 'make-compiled-procedure make-compiled-procedure)                  ; used by (compile-lambda) in ch5-compiler.scm
   (list 'compiled-procedure? compiled-procedure?)                          ; used at new apply-dispatch code below
   (list 'compiled-procedure-entry compiled-procedure-entry)                ; used by (compile-proc-appl), and at compiled-apply below
   (list 'compiled-procedure-env compiled-procedure-env)                    ; used by (compile-lambda-body) in ch5-compiler.scm 
   ))
   


   
(define eceval-compiler-register-list 
   '(expr env val proc argl continue unev
	 compapp			;*for compiled to call interpreted
	 )
)

   
(define eceval-compiler-main-controller-text
  '(
;;SECTION 5.4.4, as modified in 5.5.7
;;*for compiled to call interpreted (from exercise 5.47)                    ; new...
  (assign compapp (label compound-apply))
;;*next instruction supports entry from compiler (from section 5.5.7)       ; 1 new line from 5.5.7 p. 605
  (branch (label external-entry))                                               ; execute external code if flag is initially set - Footnote 49 p. 605
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

;;*support for entry from compiler (from section 5.5.7)                     ; new label and 4 new lines from 5.5.7 p. 605
external-entry
  (perform (op initialize-stack))                                               ; redo 2 lines, since read-eval-print-loop was skipped
  (assign env (op get-global-environment))
  (assign continue (label print-result))                                        ; assumes external instruction sequence ends with (goto (reg continue))
  (goto (reg val))                                                              ; assumes external instruction sequence is located at val on boot
                                                                                    ; from val/return linkage p. 606 in (compile-and-go) above
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

;;SECTION 5.4.1
eval-dispatch
  (test (op self-evaluating?) (reg expr))
  (branch (label ev-self-eval))
  (test (op variable?) (reg expr))
  (branch (label ev-variable))
  (test (op quoted?) (reg expr))
  (branch (label ev-quoted))
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
  (goto (label unknown-expression-type))

ev-self-eval
  (assign val (reg expr))
  (goto (reg continue))
ev-variable
  (assign val (op lookup-variable-value) (reg expr) (reg env))
  (goto (reg continue))
ev-quoted
  (assign val (op text-of-quotation) (reg expr))
  (goto (reg continue))
ev-lambda
  (assign unev (op lambda-parameters) (reg expr))
  (assign expr (op lambda-body) (reg expr))
  (assign val (op make-procedure)
              (reg unev) (reg expr) (reg env))
  (goto (reg continue))

ev-application
  (save continue)
  (save env)
  (assign unev (op operands) (reg expr))
  (save unev)
  (assign expr (op operator) (reg expr))
  (assign continue (label ev-appl-did-operator))
  (goto (label eval-dispatch))
ev-appl-did-operator
  (restore unev)
  (restore env)
  (assign argl (op empty-arglist))
  (assign proc (reg val))
  (test (op no-operands?) (reg unev))
  (branch (label apply-dispatch))
  (save proc)
ev-appl-operand-loop
  (save argl)
  (assign expr (op first-operand) (reg unev))
  (test (op last-operand?) (reg unev))
  (branch (label ev-appl-last-arg))
  (save env)
  (save unev)
  (assign continue (label ev-appl-accumulate-arg))
  (goto (label eval-dispatch))
ev-appl-accumulate-arg
  (restore unev)
  (restore env)
  (restore argl)
  (assign argl (op adjoin-arg) (reg val) (reg argl))
  (assign unev (op rest-operands) (reg unev))
  (goto (label ev-appl-operand-loop))
ev-appl-last-arg
  (assign continue (label ev-appl-accum-last-arg))
  (goto (label eval-dispatch))
ev-appl-accum-last-arg
  (restore argl)
  (assign argl (op adjoin-arg) (reg val) (reg argl))
  (restore proc)
  (goto (label apply-dispatch))
apply-dispatch
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-apply))
  (test (op compound-procedure?) (reg proc))  
  (branch (label compound-apply))
;;*next added to call compiled code from evaluator (section 5.5.7)
  (test (op compiled-procedure?) (reg proc))                                ; 2 new lines from 5.5.7 p. 604
  (branch (label compiled-apply))
  (goto (label unknown-procedure-type))

;;*next added to call compiled code from evaluator (section 5.5.7)          ; new label and 3 new lines from 5.5.7 p. 604     
compiled-apply
  (restore continue)                                                        ; pp. 553, 605: at apply-dispatch, continuation is at the top of the stack
  (assign val (op compiled-procedure-entry) (reg proc))                         ; but compiled code expects continuation in (reg continue)
  (goto (reg val))                                                              ; hmm, why not just (goto (reg proc))?

primitive-apply
  (assign val (op apply-primitive-procedure)
              (reg proc)
              (reg argl))
  (restore continue)
  (goto (reg continue))

compound-apply
  (assign unev (op procedure-parameters) (reg proc))
  (assign env (op procedure-environment) (reg proc))
  (assign env (op extend-environment)
              (reg unev) (reg argl) (reg env))
  (assign unev (op procedure-body) (reg proc))
  (goto (label ev-sequence))

;;;SECTION 5.4.2
ev-begin
  (assign unev (op begin-actions) (reg expr))
  (save continue)
  (goto (label ev-sequence))

ev-sequence
  (assign expr (op first-exp) (reg unev))
  (test (op last-exp?) (reg unev))
  (branch (label ev-sequence-last-exp))
  (save unev)
  (save env)
  (assign continue (label ev-sequence-continue))
  (goto (label eval-dispatch))
ev-sequence-continue
  (restore env)
  (restore unev)
  (assign unev (op rest-exps) (reg unev))
  (goto (label ev-sequence))
ev-sequence-last-exp
  (restore continue)
  (goto (label eval-dispatch))

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
   ))

; default evaluator
(define eceval
  (make-machine
   eceval-compiler-register-list
   eceval-operations
   eceval-compiler-main-controller-text))
   
'(EXPLICIT CONTROL EVALUATOR FOR COMPILER LOADED)