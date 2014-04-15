; this file is also not meant to be run; it's a scheme file just for syntax coloring.

; could try to run (runtime) from Exercises 1.22-24.
; This returns the system time, so you have to take differences.
; but running it at the mit-scheme prompt always gives either .016 or .032? 
    ; do you have to embed it into the function you're running? ugh
    ; just run a stopwatch somehwere...

; sols have some nice simple tests that i think i wouldn't mind running
; http://community.schemewiki.org/?sicp-ex-4.24

; 4-24.test1.scm   
(define (loop n) 
    (if (> n 0) 
        (loop (- n 1)))) 
 
(loop 100000) ; down from 1000000 - is this just slower on Windows??
(exit) 
; for reference, native scheme ran 10x as many iterations in ~10 sec!
; ch4-mceval.scm: ~19 sec
; ch4-analyzingmceval.scm: 11.28s. a LOT faster. ~50% time was being spent in parsing!?



; 4-24.test2.scm 
 
(define (fib n) 
    (if (<= n 2) 
        1 
        (+ (fib (- n 1)) (fib (- n 2))))) 
 
(fib 30)  ; meh, this was too slow on Windows, and I didn't feel like typing TWO more times
(exit) 
