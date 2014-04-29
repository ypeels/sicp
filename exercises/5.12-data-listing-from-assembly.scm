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

    
; it's ALL ABOUT THE DATA STRUCTURES. (although assignment plays a bit of a role too)
    

; not init to '() so that (append!) will work
; fwiw, the headers make the sets somewhat self-documenting if printed outside a table...
(define (make-dataset)             
    (let ((dataset '()))            
        (define (adjoin! datum)
            (if (not (is-in-dataset? datum))
                (set! dataset (cons datum dataset))))                
        (define (print)
            (display dataset)
            (newline))
        (define (is-in-dataset? datum) ; private helper function
            (cond
                ((symbol? datum) (memq datum dataset))
                ((list? datum) (member datum dataset))
                (else (error "Unknown data type -- IS-IN-dataset?" datum))))
        (define (dispatch message)
            (cond
                ((eq? message 'adjoin!) adjoin!)
                ((eq? message 'print) (print))
                (else (error "Unknown operation -- DATASET" message))))
        dispatch))

(define (adjoin-to-dataset! datum dataset)
    ((dataset 'adjoin!) datum))

(define (print-dataset dataset)
    (dataset 'print))
    

    
; the rest of this solution "overrides" existing functions in ch5-regsim.scm
    ; that is, they add a bit of functionality, then call the existing functions.
    ; this way, readers (the author included) don't have to compare code
        ; just to figure out what was added/changed.
        
    

; implemented as a "facade" in front of the old machine
(define (make-new-machine-5.12)             
  (let ((machine-regsim (make-new-machine-regsim)) ; "base object" or "delegate" 
        (dataset-table                                          
            (list 
                (list 'assign (make-dataset))
                (list 'branch (make-dataset))
                (list 'goto (make-dataset))
                (list 'perform (make-dataset))
                (list 'restore (make-dataset))
                (list 'save (make-dataset))
                (list 'test (make-dataset))

                (list 'goto-registers (make-dataset))
                (list 'save-registers (make-dataset))
                (list 'restore-registers (make-dataset))))
              
        ; register names are determined by the user, so these should be stored separately
            ; sure, it'd take one sick cookie to name a register 'goto',
            ; but a register named 'test' is not inconceivable.
            ; also, a user could technically manipulate pc and flag directly
        (assign-dataset-table
            (list
                (list 'pc (make-dataset))
                (list 'flag (make-dataset)))))
        
    ; "public procedures"
    (define (allocate-register-5.12 name)        
      (set! assign-dataset-table
            (cons  ; no duplicate checking - original regsim will crash on that anyway
              (list name (make-dataset))
              assign-dataset-table))                
      ((machine-regsim 'allocate-register) name))
      
    (define (lookup-dataset name)
        (lookup-dataset-in-table name dataset-table))
        
    (define (lookup-assign-dataset name)
        (lookup-dataset-in-table name assign-dataset-table))   

    (define (print-all-datasets)
        (print-dataset-table dataset-table "Instructions and registers used")
        (print-dataset-table assign-dataset-table "Assignments"))      
      
    ; "private procedures" (cannot be invoked from outside the object) 
    (define (lookup-dataset-in-table name table)
        (let ((val (assoc name table)))
            (if val
                (cadr val)
                (error "dataset not found -- GET-DATASET-FROM-TABLE" name table))))      
        
    (define (print-dataset-table table title)
        (newline)
        (display title)
        (newline)
        (for-each 
            (lambda (table-entry) 
                (display (car table-entry))
                (display ": ")
                (print-dataset (cadr table-entry)))
            table))
      
    ; expose public API
    (define (dispatch message)
      (cond               
        ; one override
        ((eq? message 'allocate-register) allocate-register-5.12)              

        ; new messages
        ((eq? message 'print-all-datasets) (print-all-datasets))
        ((eq? message 'lookup-dataset) lookup-dataset)
        ((eq? message 'lookup-assign-dataset) lookup-assign-dataset)

        ; punt everything else to "base class" / delegate - INCLUDING error handling
        (else (machine-regsim message))))                         
    dispatch))   
    

    
(define (make-execution-procedure-5.12 inst labels machine pc flag stack ops)  
    (let ((dataset ((machine 'lookup-dataset) (car inst))))
        (adjoin-to-dataset! (cdr inst) dataset))    
    (make-execution-procedure-regsim inst labels machine pc flag stack ops))    

(define (make-goto-5.12 inst machine labels pc) 
    (let ((dest (goto-dest inst)))  ; duplicated 2 lines of supporting logic
        (if (register-exp? dest)
            (let ((dataset ((machine 'lookup-dataset) 'goto-registers)))
                (adjoin-to-dataset! (register-exp-reg dest) dataset))))                 
    (make-goto-regsim inst machine labels pc)) ; punt to ch5-regsim.scm
                       
(define (make-save-5.12 inst machine stack pc)        
    (let ((dataset ((machine 'lookup-dataset) 'save-registers)))
        (adjoin-to-dataset! (stack-inst-reg-name inst) dataset))
    (make-save-regsim inst machine stack pc))

(define (make-restore-5.12 inst machine stack pc)                       
    (let ((dataset ((machine 'lookup-dataset) 'restore-registers)))
        (adjoin-to-dataset! (stack-inst-reg-name inst) dataset))
    (make-restore-regsim inst machine stack pc))      

(define (make-assign-5.12 inst machine labels operations pc)    
    (let ((dataset ((machine 'lookup-assign-dataset) (assign-reg-name inst))))
        (adjoin-to-dataset! (assign-value-exp inst) dataset))
    (make-assign-regsim inst machine labels operations pc))        


   
      
; -------------------------------------------------------------------------
      
; example usage.
      
(load "ch5-regsim.scm")

; make the overrides official.
(define make-new-machine-regsim make-new-machine) 
(define make-new-machine make-new-machine-5.12) 

(define make-goto-regsim make-goto) 
(define make-goto make-goto-5.12)

(define make-save-regsim make-save) 
(define make-save make-save-5.12)

(define make-restore-regsim make-restore) 
(define make-restore make-restore-5.12)

(define make-assign-regsim make-assign) 
(define make-assign make-assign-5.12)

(define make-execution-procedure-regsim make-execution-procedure) 
(define make-execution-procedure make-execution-procedure-5.12)

; i uploaded a version of this to http://community.schemewiki.org/?sicp-ex-5.12
; anonymous? i didn't even SEE a way to stick my name on it...oh well, it's the work that matters

(load "5.06-fibonacci-extra-push-pop.scm")
(define fib-machine (make-fib-machine-5.6))
(test-5.6-long) ; regression test
(fib-machine 'print-all-datasets) ; test new functionality

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





