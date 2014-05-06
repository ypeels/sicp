(define (test-regsim)
    (load "ch5-regsim.scm")
    (load "5.11a-stack-exploit.scm") ; the fully optimized version
    
    (define (test n)
        (display "\nFib of ") (display n)
        (let ((machine (make-fib-machine-5.11a)))
            (set-register-contents! machine 'n n)
            ((machine 'stack) 'initialize)
            (start machine)
            ((machine 'stack) 'print-statistics)
        )
    )
    (for-each test '(0 1 2 3 4 5 6 7 8 9 10))
)
;(test-regsim)
; stack statistics    
; n       total   max 
; 0-1     0       0
; 2       3       2
; 3       6       4
; 4       12      6
; 5       21      8
; 6       36      10
; 7       60      12
; 8       99      14
; 9       162     16
; 10      264     18
;                 2(n-1) 
        

; take a hint from meteorgan and use results from 5.29
; eceval 
; max depth(n) = 5n + 3 ---> 2.5x regsim. same as factorial!! spooky...
; total pushes(n) = 56 Fib(n+1) - 40. erm, empirical value hovers around 19x regsim.


(define (test-compiler)
    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm") ; for (compile-and-go) testing
    
    ;(load "5.38-open-coded-primitives.scm") (install-compile-5.38)

    (compile-and-go 
        '(begin
            
            ; modified from problem statement
            (define (f n)
              (if (< n 2)
                  n
                  (+ (f (- n 1)) (f (- n 2)))))
            "Fibonacci defined as (f n)"
        )
    )
)
(test-compiler)
; stack statistics    
; n       total   max  
; 0-1     7       3   
; 2       17      5
; 3       27      8
; 4       47      11    
; 5       77      14
; 6       127     17
; 7       207     20
; 8       337     23
; 9       547     26
; 10      887     29
;                 3n-1 --> 1.5x regsim. same as factorial here too!!! a property of the compiler??
; total pushes(n) decreases to around 3.35x regsim.
    


; how much would open coding help here?
    ; the main problem is the tree-recursion, so i figure, not so much...    
; with open-coding
; n       total   max  
; 0-1     7       3   
; 2       14      4
; 3       21      6
; 4       35      8
; 5       56      10
; 6       91      12
; 7       147     14
; 8       238     16
; 9       385     18
; 10      623     20
;                 2n ---> 1x regsim. doesn't get much better!
; total pushes(n) decreases to around 2.36x regsim
    ; so it helps SOME
    ; if i really cared, i'd compare the compiler output (assembly code) with Figure 5.12 like l0stman, that trooper
    
    
    ; maybe implement some sort of memoization?
        ; would have to make sure that it's a non-mutating procedure
    ; the best cure here, really, is algorithmic
        ; iterative algorithm for space (stack)
        ; fast iterative algorithm (1.19) for speed
        
        
; omfg, this is the last Exercise on Fibonacci!!!