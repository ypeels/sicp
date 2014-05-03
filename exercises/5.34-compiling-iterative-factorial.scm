(load "5.33-38-compiling-to-file.scm")

(define (compile-fact-iter)
    (compile-to-file
        '(define (factorial n)
          (define (iter product counter)
            (if (> counter n)
                product
                (iter (* counter product)
                      (+ counter 1))))
          (iter 1 1))
        'val
        'next
        "5.34-factorial-iterative.asm"
    )
)

(compile-fact-iter)



; the difference

; Figure 5.17 (recursive factorial)
; ---------------------------------
;   (restore proc) ; restore factorial
; ;; apply factorial
;   (test (op primitive-procedure?) (reg proc))
;   (branch (label primitive-branch11))
; compiled-branch10
;   (assign continue (label after-call9))                               ; <====== NOT tail recursive! this is the control difference...
;   (assign val (op compiled-procedure-entry) (reg proc))
;   (goto (reg val))
; primitive-branch11
;   (assign val (op apply-primitive-procedure) (reg proc) (reg argl))

; after-call9      ; val now contains result of (factorial (- n 1))
;   (restore argl) ; restore partial argument list for *                ; <=== and this is the data difference. argl stack accumulates.
;   (assign argl (op cons) (reg val) (reg argl))

    ; the reason is that the linkage for (factorial (- n 1)) is after-call9
    ; and that's because the function isn't DONE after recursion
        ; still need to perform a multiplication

        
; result of (compile-fact-iter)
; -----------------------------
;   (restore proc)                                                                        ; proc = iter
;   (restore continue)
;   (test (op primitive-procedure?) (reg proc))                                           ; evaluate (iter argl)
;   (branch (label primitive-branch19))                            
; compiled-branch18
;   (assign val (op compiled-procedure-entry) (reg proc))
;   (goto (reg val))                                                                      ; <===== return linkage!
; primitive-branch19                                                                          ; not coming back here again.
;   (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;   (goto (reg continue))

    ; composite functions at the end of a procedure are called tail-recursively.