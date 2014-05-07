; the exercise gives you the hints you need
; you're not supposed to modify the compiler, or even eceval.
; create a NEW STUPID MACHINE that
    ; takes scheme expressions as input
    ; calls (compile 'val 'return) and assemble on the input
    ; prints the result in val
    ; uses the eceval-operations runtime (I think)
    ; maintains eceval's register set so that env, etc. 

; basically, this entire exercise is just about writing 3 new lines of assembly code at comp-exec
    ; expr = scheme expression from user
    ; continue = print-result

; another cursed existence with little to no utility
    ; 5.48 yielded a compiling interpreter - typing expressions is slower than compiling in batch
    ; 5.49 yielded an interpreting compiler - compiling expressions is (possibly?) slower than interpreting

; can i do this by using ONLY the (op)'s needed by eceval-instructions-5.49, and nothing more? 
    ; no, assembler needs lookup-variable-value, etc. runtime    
    
; meh, this is in ch5-eceval-compiler.scm, which i needed to (load) for eceval-operations
;(define the-global-environment '())  

; huh? stack statistics are not working??
    ; oh, you have to RUN a procedure that has pushes
    ; defining factorial won't cause any push/pops
    
; removed development comments and code for uploading to wiki
    ; see previous Git commit

    
; everything below uploaded to http://community.schemewiki.org/?sicp-ex-5.49
; pity i forsook my idiosyncratic (set!) etc. usages
    ; but what are the odds i'll ever (load) this file into ANYTHING??
    ; one more to go!!!
   
(load "ch5-regsim.scm") ; for (make-machine) and (assemble)
(load "ch5-compiler.scm") ; for (compile)
(load "ch5-eceval-support.scm") ; for syntax and utility procedures
(load "ch5-eceval-compiler.scm") ; for operation list, needed by assembler

; return linkage makes compiled code return to print-result below
(define (compile-and-assemble expr)
    (assemble   
        (statements (compile expr 'val 'return))
        ec-comp-exec))

; compiler expects same register set as eceval
(define ec-comp-exec-registers
    '(expr env val proc argl continue unev))
    
(define ec-comp-exec-operations 
    (append 
        eceval-operations ; from ch5-eceval-compiler.scm
        (list (list 'compile-and-assemble compile-and-assemble))))    
    
    
    
(define ec-comp-exec-controller-text '(

; main loop same as eceval
read-compile-exec-print-loop
    (perform (op initialize-stack)) 
    (perform (op prompt-for-input) (const ";;; EC-Comp-Exec input:"))
    (assign expr (op read))
    (assign env (op get-global-environment))
    (assign continue (label print-result)) 
    (goto (label compile-and-execute)) ; ** label name changed
print-result
    (perform (op print-stack-statistics))
    (perform (op announce-output) (const ";;; EC-Comp-Exec value:"))
    (perform (op user-print) (reg val))
    (goto (label read-compile-exec-print-loop))

    
; the entirety of the new machine! as per the problem statement, 
; all complexity is deferred to "primitives" (compile) and (assemble)
compile-and-execute
    (assign val (op compile-and-assemble) (reg expr))
    (goto (reg val))
    
))



(define ec-comp-exec (make-machine
    ec-comp-exec-registers
    ec-comp-exec-operations 
    ec-comp-exec-controller-text))

(define (start-ec-comp-exec)
    (set! the-global-environment (setup-environment))
    (ec-comp-exec 'start)
)

(start-ec-comp-exec)

        
        