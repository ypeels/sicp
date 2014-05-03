  (assign val (op make-compiled-procedure) (label entry2) (reg env))        ; (define (factorial n) ...)
  (goto (label after-lambda1))                                                  ; skip over procedure body
entry2                                                                      ; body of (factorial)
  (assign env (op compiled-procedure-env) (reg proc))
  (assign env (op extend-environment) (const (n)) (reg argl) (reg env))
  (assign val (op make-compiled-procedure) (label entry7) (reg env))            ; (define (iter product counter) ... )
  (goto (label after-lambda6))                                                      ; skip over procedure body
entry7                                                                          ; body of (iter)
  (assign env (op compiled-procedure-env) (reg proc))
  (assign env (op extend-environment) (const (product counter)) (reg argl) (reg env))
  (save continue)
  (save env)
  (assign proc (op lookup-variable-value) (const >) (reg env))                      ; predicate (> counter n)
  (assign val (op lookup-variable-value) (const n) (reg env))
  (assign argl (op list) (reg val))
  (assign val (op lookup-variable-value) (const counter) (reg env))
  (assign argl (op cons) (reg val) (reg argl))
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-branch22))
compiled-branch21
  (assign continue (label after-call20))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch22
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call20
  (restore env)
  (restore continue)                                                                ; result: val = (> counter n)
  (test (op false?) (reg val))                                                      ; (if (> counter n))
  (branch (label false-branch9))
true-branch10
  (assign val (op lookup-variable-value) (const product) (reg env))                     ; product
  (goto (reg continue))
false-branch9
  (assign proc (op lookup-variable-value) (const iter) (reg env))                       ; (iter
  (save continue)
  (save proc)
  (save env)
  (assign proc (op lookup-variable-value) (const +) (reg env))                              ; (+
  (assign val (const 1))
  (assign argl (op list) (reg val))
  (assign val (op lookup-variable-value) (const counter) (reg env))
  (assign argl (op cons) (reg val) (reg argl))                                                  ; counter 1)
  (test (op primitive-procedure?) (reg proc))                                               ; evaluate (+ counter 1)
  (branch (label primitive-branch16))
compiled-branch15
  (assign continue (label after-call14))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch16
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call14                                                                                ; result: val = (+ counter 1)
  (assign argl (op list) (reg val))                                                         ; argl = (value(+ counter 1))
  (restore env)
  (save argl)
  (assign proc (op lookup-variable-value) (const *) (reg env))                              ; (*    
  (assign val (op lookup-variable-value) (const product) (reg env))
  (assign argl (op list) (reg val))
  (assign val (op lookup-variable-value) (const counter) (reg env))
  (assign argl (op cons) (reg val) (reg argl))                                                  ; counter product)
  (test (op primitive-procedure?) (reg proc))                                               ; evaluate (* counter product)    
  (branch (label primitive-branch13))
compiled-branch12
  (assign continue (label after-call11))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch13
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call11                                                                                ; result: val = (* counter product)
  (restore argl)
  (assign argl (op cons) (reg val) (reg argl))                                              ; argl = (value(* counter product) value (+ counter 1))
  (restore proc)                                                                        ; proc = iter
  (restore continue)
  (test (op primitive-procedure?) (reg proc))                                           ; evaluate (iter argl)
  (branch (label primitive-branch19))                            
compiled-branch18
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))                                                                      ; <===== next iter is called tail-recursively!!
primitive-branch19
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
  (goto (reg continue))
after-call17
after-if8
after-lambda6
  (perform (op define-variable!) (const iter) (reg val) (reg env))
  (assign val (const ok))                                                   ; end of (iter) definition.
  (assign proc (op lookup-variable-value) (const iter) (reg env))           ; proc = iter
  (assign val (const 1))
  (assign argl (op list) (reg val))
  (assign val (const 1))
  (assign argl (op cons) (reg val) (reg argl))                              ; argl = (1 1)
  (test (op primitive-procedure?) (reg proc))                               ; (iter 1 1)
  (branch (label primitive-branch5))
compiled-branch4
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))                                                          ; so (iter 1 1) was called tail-recursively, but who cares about that?
primitive-branch5
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
  (goto (reg continue))                                               
after-call3                                                           
after-lambda1
  (perform (op define-variable!) (const factorial) (reg val) (reg env))
  (assign val (const ok))
