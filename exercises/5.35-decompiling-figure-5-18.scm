; my answer: (define (f x) (+ x (g (+ x 2))))
; how do i run the compiler to check?

; from ch5.scm

;;EXERCISE 5.35 (FIGURE 5.18)
  (assign val (op make-compiled-procedure) (label entry16)              ; (define (f x)
                                           (reg env))                       
  (goto (label after-lambda15))                                             ; function name from after-lambda15
entry16
  (assign env (op compiled-procedure-env) (reg proc))
  (assign env
          (op extend-environment) (const (x)) (reg argl) (reg env))         ; parameter list from here.
  (assign proc (op lookup-variable-value) (const +) (reg env))              ; (+
  (save continue)
  (save proc)
  (save env)
  (assign proc (op lookup-variable-value) (const g) (reg env))                  ; (g 
  (save proc)
  (assign proc (op lookup-variable-value) (const +) (reg env))                      ; (+ 
  (assign val (const 2))                                                                 
  (assign argl (op list) (reg val))                                                     ; argl = (2)
  (assign val (op lookup-variable-value) (const x) (reg env))                           
  (assign argl (op cons) (reg val) (reg argl))                                          ; argl = (x 2)
  (test (op primitive-procedure?) (reg proc))                                       ; start (+ x 2)
  (branch (label primitive-branch19))
compiled-branch18                               ; note that the COMPILER has no idea whether a function is primitive
  (assign continue (label after-call17))        ; that's up to regsim "hardware"! hence the last sentence on p. 594. (naively, you wouldn't expect save/restore to be necessary for =)
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch19
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call17
  (assign argl (op list) (reg val))                                                 ; argl = value(+ x 2)
  (restore proc)                                                                ; proc = g
  (test (op primitive-procedure?) (reg proc))                                   ; start (g value(+ x 2))
  (branch (label primitive-branch22))
compiled-branch21
  (assign continue (label after-call20))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch22
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call20
  (assign argl (op list) (reg val))                                             ; argl = (g value(+ x 2))
  (restore env)
  (assign val (op lookup-variable-value) (const x) (reg env))
  (assign argl (op cons) (reg val) (reg argl))                              ; argl = (x value(g (+ x 2)))
  (restore proc)                                                            ; proc = +
  (restore continue)
  (test (op primitive-procedure?) (reg proc))                               ; start (+ x value(g (+ x 2)))
  (branch (label primitive-branch25))
compiled-branch24
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch25
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
  (goto (reg continue))
after-call23
after-lambda15
  (perform (op define-variable!) (const f) (reg val) (reg env))
  (assign val (const ok))
;;end of exercise

