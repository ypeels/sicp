;Extend the assembler to store the following information in the machine model:
; a list of all instructions, with duplicates removed, sorted by instruction type (assign, goto, and so on);
    ; table of lists
    ; it doesn't ask for the instructions to be sorted WITHIN a type, so no need to dig back to chapter 2 for sorted lists
    ; not that easy... do this at the beginning of (make-execution-procedure)
        ; must be done for EVERY instruction
        ; could do this in (update-insts!), but the syntax there is whacked
        ; could do this in (assemble) or earlier, but then you'd have to identify and ignore labels.
        ; could do this in (make-instruction), but then you'd have to pass machine in somehow.

; a list (without duplicates) of the registers used to hold entry points (these are the registers referenced by goto instructions);
    ; easy! do this at the beginning of the register case in (make-goto).

; a list (without duplicates) of the registers that are saved or restored
    ; easy! do this at the beginning of (make-save) and (make-restore).

; for each register, a list (without duplicates) of the sources from which it is assigned 
; (for example, the sources for register val in the factorial machine of figure 5.11 are 
; (const 1) and ((op *) (reg n) (reg val))). 
    ; do this at the beginning of (make-assign)

    
; but the question is how to do all of this effectively and consistently...
    ; b and c are easy - you're just appending register names into an instruction-specific list
        ; share this operation between b and c!
    ; d is similar, but you need one list PER REGISTER
        ; in other words, a 2-d table
        ; if you look up the register's list, you could use the operation from b/c...
            ; provided that you use (member) to test for uniqueness and not (memq)
    ; a is actually similar to d, except that the table rows are KNOWN from p. 513.
    
    ; could create a gigantic merged 2-d table, but there MIGHT be name collisions from register names
    ; should probably create 3 1-d tables and 2 2-d tables (start by testing the former)
    
    
    
; datalist functions moved outside of the machine, like registers
; however, registers are themselves data-directed objects
; by analogy, 
    ; i think it would be cleanest if the lookup were done at the machine level, 
    ; and then the (make) functions worked directly with datalists.


; not init to '() so that (append!) will work
; fwiw, the headers make the sets somewhat self-documenting if printed outside a table...
(define (make-empty-dataset sym)                                   
    (list (string->symbol (string-append                                               
        "*" (symbol->string sym) "*"))))


    


(define (is-in-dataset? datum dataset)
    (cond
        ((symbol? datum) (memq datum (cdr dataset)))   ; first entry is a dummy header
        ((list? datum) (member datum (cdr dataset)))
        (else (error "Unknown data type -- IS-IN-dataset?" datum))))
        
(define (add-to-dataset! datum dataset)
    (if (not (is-in-dataset? datum dataset))
        (append! dataset (list datum))))            

; dataset table functions. figuring out my data structures was 90% of the battle



    


    
; new data structures for logging
; new interface function to dump logs
(define (make-new-machine-5.12)             
  (let ((machine-regsim (make-new-machine-regsim))                      ; "base object" (or the delegate behind the facade)
        
        ; 
        (dataset-table                                     ; cf. operation and register tables, which were initialized similarly
            (list
                (cons 'assign (make-empty-dataset 'assign))
                (cons 'branch (make-empty-dataset 'branch))
                (cons 'goto (make-empty-dataset 'goto))
                (cons 'perform (make-empty-dataset 'perform))
                (cons 'restore (make-empty-dataset 'restore))
                (cons 'save (make-empty-dataset 'save))
                (cons 'test (make-empty-dataset 'test))
                
                ; previously separate 1-d sets
                (cons 'goto-registers (make-empty-dataset 'goto-registers))
                (cons 'save-registers (make-empty-dataset 'save-registers))
                (cons 'restore-registers (make-empty-dataset 'restore-registers))))
              
        ; register names are determined by the user, so these should be stored separately
            ; Sure, it'd take one sick cookie to name a register 'goto',
            ; But a register named 'test' is not inconceivable.
            ; Also, a user could technically manipulate pc and flag directly
        (assign-dataset-table
            (list
                (cons 'pc (make-empty-dataset 'pc))
                (cons 'flag (make-empty-dataset 'flag)))))
        
    (define (allocate-register-5.12 name)        
      (set! assign-dataset-table                                             ; <---- new: keep track of data sources for each register's (assign)'s
            (cons                                                             ; no duplicate checking - original regsim will crash on that anyway
              (list name (make-empty-dataset name))
              assign-dataset-table))                
      ((machine-regsim 'allocate-register) name))
      
    (define (lookup-dataset name table)
        (let ((dataset (assoc name table)))
            (if dataset
                dataset ; NOT cadr, since I used cons instead of 
                (error "dataset not found -- GET-DATASET-FROM-TABLE" name table))))
      
    
    (define (add-to-instruction-datasets! instruction-type expr)
      (let ((dataset (lookup-dataset instruction-type dataset-table)))
          (add-to-dataset! expr dataset))) 

    (define (add-to-entry-dataset! register-name)
      (add-to-dataset! 
        register-name 
        (lookup-dataset 'goto-registers dataset-table)))
      
    (define (add-to-save-dataset! register-name)
      (add-to-dataset! 
        register-name 
        (lookup-dataset 'save-registers dataset-table)))
      
    (define (add-to-restore-dataset! register-name)
      (add-to-dataset! 
        register-name 
        (lookup-dataset 'restore-registers dataset-table)))
        

    ; assignments go into a different table
    (define (add-to-assign-datasets! register-name value-exp)
      (let ((dataset (lookup-dataset register-name assign-dataset-table)))
          (add-to-dataset! value-exp dataset)))    

    ; for displaying results
    (define (print-all-datasets)
        (print-dataset-table dataset-table "Instructions and registers used")
        (print-dataset-table assign-dataset-table "Assignments"))
        
    (define (print-dataset-table table title)
        (newline)
        (display title)
        (newline)
        (for-each 
            (lambda (table-entry) 
                (display (cdr table-entry)) 
                (newline))
            table))
          
          
    
     
      
      
      
    (define (dispatch message)
      (cond               
            ; one override
            ((eq? message 'allocate-register) allocate-register-5.12)              
            
            ; new functions
            ((eq? message 'print-all-datasets) (print-all-datasets))
            ((eq? message 'log-entry) add-to-entry-dataset!)
            ((eq? message 'log-save) add-to-save-dataset!)
            ((eq? message 'log-restore) add-to-restore-dataset!)
            ((eq? message 'log-assign) add-to-assign-datasets!)
            ((eq? message 'log-instruction) add-to-instruction-datasets!)
            (else (machine-regsim message))))                         ; punt everything else to "base class" / delegate - INCLUDING error handling
    dispatch))      

(define (make-goto-5.12 inst machine labels pc)                         ; modified for case b.
    (let ((dest (goto-dest inst)))
        (if (register-exp? dest)
            ((machine 'log-entry) (register-exp-reg dest))))            ; <---- new logging code (1 new line, plus supporting logic)
    (make-goto-regsim inst machine labels pc))
                       
(define (make-save-5.12 inst machine stack pc)                          ; modified for case c
    ((machine 'log-save) (stack-inst-reg-name inst))                    ; <---- new logging code (1 line)
    (make-save-regsim inst machine stack pc))

(define (make-restore-5.12 inst machine stack pc)                       
    ((machine 'log-restore) (stack-inst-reg-name inst))                 ; <---- new logging code (1 line)
    (make-restore-regsim inst machine stack pc))      

(define (make-assign-5.12 inst machine labels operations pc)            ; modified for case d
    ((machine 'log-assign) (assign-reg-name inst) (assign-value-exp inst))
    (make-assign-regsim inst machine labels operations pc))        

(define (make-execution-procedure-5.12 inst labels machine              ; modified for case a
                                  pc flag stack ops)  
    ((machine 'log-instruction) (car inst) (cdr inst))                  ; <---- new logging code (1 line)
    (make-execution-procedure-regsim inst labels machine
        pc flag stack ops))
   
      
; -------------------------------------------------------------------------
      
      
(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")

; overrides - but saving the "base class procedure" for reuse/punting
(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.12) 
(define make-goto-regsim make-goto) (define make-goto make-goto-5.12)
(define make-save-regsim make-save) (define make-save make-save-5.12)
(define make-restore-regsim make-restore) (define make-restore make-restore-5.12)
(define make-assign-regsim make-assign) (define make-assign make-assign-5.12)
(define make-execution-procedure-regsim make-execution-procedure) (define make-execution-procedure make-execution-procedure-5.12)

(define fib-machine (make-fib-machine-5.6))

; regression test
(test-5.6-long)

; test new functionality
(fib-machine 'print-all-datasets)

; ;;; Results - cf. p. 497
; Registers used by goto
; continue
; 
; Registers used by save
; continue
; n
; val
; 
; Registers used by restore (in order of appearance)
; n
; val
; continue
; 
; Values for register continue
; (label fib-done)
; (label afterfib-n-1)
; (label afterfib-n-2)
; 
; Values for register val
; ((op +) (reg val) (reg n))
; (reg n)
; 
; Values for register n
; ((op -) (reg n) (const 1))
; ((op -) (reg n) (const 2))
; (reg val)
; 
; Assign instructions 
; continue (label fib-done)
; continue (label afterfib-n-1)
; n (op -) (reg n) (const 1)
; n (op -) (reg n) (const 2)
; continue (label afterfib-n-2)
; n (reg val)
; val (op +) (reg val) (reg n)
; val (reg n)
; 
; Branch instructions
; label immediate-answer
; 
; Goto instructions
; label fib-loop
; reg continue
; 
; Perform instructions: none
; 
; Restore instructions
; n
; val
; continue
; 
; Save instructions
; continue
; n
; val
; 
; Test instructions
; (op <) (reg n) (const 2)





