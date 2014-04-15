; this file is NOT meant to be run or loaded
; it's kept as an scm file so that you have syntax highlighting.

; The version in the book "pre-compiles" a huge lambda that contains ALL the procs in the sequence:
(lambda (env) proc1 proc2 ... procN)

; Proof
(sequentially first-proc (car rest-procs))
	= (lambda (env) (first-proc env) ((car rest-procs) env)) ; call this proc12, a function of env.
    
    
; Next iteration of (loop)
(sequentially proc12 (car rest-procs))
    = (lambda (env) (proc12 env) (proc3 env)) ; call this proc123, a function of env
    := (proc123 env)
    
    
; etc., eventually returning proc123...N, still a function with single argument env.
    ; when applied, 
(proc123...N env)
    = (proc123...N-1 env) (procN env)
    = (proc123...N-2 env) (procN-1 env) (procN env)
    = ...
    ; so you see, (loop) + (sequentially) "pre-compile" the list of procs into a big lambda that executes them sequentially.
    ; Alyssa's version would have to loop through the proc list every time the sequence was executed.
        ; doesn't SEEM like it would be much additional overhead, but that's not the spirit of this section...

; specific examples
; sequence is a single procedure
    ; textbook version
        ; rest-procs is null in the first iteration
        ; just returns first-proc, without the extra overhead of a redundant wrapping lambda
            ; this works because, as you can see from ((car procs) env), first-proc is a function of env.
    ; alyssa's version
        ; returns (lambda (env) (execute-sequence procs env))
            ; doesn't execute this up front, so invocations will have to run the one-item loop again and again
            
; sequence is 2 procedures
    ; textbook version
        ; will return proc2 = (lambda (env) (proc1 env) (proc2 env))
    ; alyssa's version
        ; still returns (lambda (env) (execute-sequence procs env))
            ; invocations will have to run this entire TWO-item loop again and agian.
        
    
    