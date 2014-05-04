; I guess output the object code to file as in 5.35, and analyze by diff?
; should just be ordering differences
; how am i supposed to run this code?? 
    ; should i come back and finish this after reading 5.5.7?
    ; should i look at "load-eceval-compiler"?
    ; either way, i'm not doing this on my tiny netbook screen at howdy honda...

    
(load "5.33-38-compiling-to-file.scm")

(define (compile-fact)
    (compile-to-file
        '(define (factorial n)
          (if (= n 1)
              1
              (* (factorial (- n 1)) n)))
        'val
        'next
        "5.33-factorial.asm"
    )
)

(define (compile-fact-alt)
    (compile-to-file
        '(define (factorial-alt n)
          (if (= n 1)
              1
              (* n (factorial-alt (- n 1)))))
        'val
        'next
        "5.33-factorial-alt.asm"
    )
)

;(compile-fact)
;(compile-fact-alt) ; why am i only able to execute ONE of these??

; "Explain any differences you find."


; there are surprisingly FEW changes

; in any case, here's the diff, reordered

; < is factorial
; 33,36c33,34
; ; <   (assign val (op lookup-variable-value) (const n) (reg env))
; ; <   (assign argl (op list) (reg val))
; <   (save argl)
; ; <   (assign proc (op lookup-variable-value) (const factorial) (reg env))
; 63c61,63
; <   (restore argl)

; > is factorial-alt 
; 33,36c33,34
; >   (save env)
; ; >   (assign proc (op lookup-variable-value) (const factorial-alt) (reg env))
; 63c61,63
; ; >   (assign argl (op list) (reg val))
; >   (restore env)
; ; >   (assign val (op lookup-variable-value) (const n) (reg env))



; conserved
; (assign val n env)
; (assign proc <some factorial procedure> env)
; (assign argl (op list) val)

; and the difference is WHICH register is push/popped
; factorial: save/restore env
    ; the recursive call trashes argl, which you need to restore to do (* fact n)
    ; BUT env need not be read anymore (value of n is stored in [saved] argl), so no need to 
; factorial-alt: save/restore argl
    ; the recursive call is FIRST, so you need to restore env to lookup n
    ; but argl = (factorial-alt (- n 1)) is the initial write, so there is no need to preserve it.

; same number of instructions of the same type; therefore the performance is unchanged.


; the other difference: duh, the function names have changed
; 78c78
; <   (perform (op define-variable!) (const factorial) (reg val) (reg env))
; ---
; >   (perform (op define-variable!) (const factorial-alt) (reg val) (reg env))
