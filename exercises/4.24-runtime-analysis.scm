; could try to run (runtime) from Exercises 1.22-24.
; This returns the system time, so you have to take differences.
; but running it at the mit-scheme prompt always gives either .016 or .032? 
    ; do you have to embed it into the function you're running? ugh
    ; just run a stopwatch somehwere...

; sols have some nice simple tests that i think i wouldn't mind running

; ; 4-24.test1.scm   
; (define (loop n) 
;     (if (> n 0) 
;         (loop (- n 1)))) 
;  
; (loop 1000000) 
; (exit) 
;
; ; 4-24.test2.scm 
;  
; (define (fib n) 
;     (if (<= n 2) 
;         1 
;         (+ (fib (- n 1)) (fib (- n 2))))) 
;  
; (fib 30) 
; (exit) 
