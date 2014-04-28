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
    

    
; new data structures for logging
; new interface function to dump logs
(define (make-new-machine-5.12)                                             
  (let ((pc (make-register 'pc))                                       
        (flag (make-register 'flag))                                   
        (stack (make-stack))
        (the-instruction-sequence '())
        (entry-datalist '(*entry-datalist*))                            ; <---- new data structures
        (save-datalist '(*save-datalist*))                              ; not init to empty because of (append!) quirk...
        (restore-datalist '(*restore-datalist*))
       )                                
    (let ((the-ops                                                     
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))                
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics                         
                       (lambda () (stack 'print-statistics)))))
          (register-table                                              
           (list (list 'pc pc) (list 'flag flag))))                    
      (define (allocate-register name)                                 
        (if (assoc name register-table)                                
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)                                   
        (let ((val (assoc name register-table)))                       
          (if val                                                      
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))                               
          (if (null? insts)
              'done
              (begin                                                   
                ((instruction-execution-proc (car insts)))             
                (execute)))))        
      (define (print-datalists)                                         ; <---- new procedures
        (display "\n\nRegisters used by (goto)\n")
        (display (cdr entry-datalist))
        (display "\n\nRegisters used by (save)\n")
        (display (cdr save-datalist))
        (display "\n\nRegisters used by (restore)\n")
        (display (cdr restore-datalist))
      )
      (define (add-to-entry-datalist! register-name)
        (add-to-datalist! register-name entry-datalist))
      (define (add-to-save-datalist! register-name)
        (add-to-datalist! register-name save-datalist))
      (define (add-to-restore-datalist! register-name)
        (add-to-datalist! register-name restore-datalist))
      (define (is-in-datalist? datum datalist)
        (cond
            ((symbol? datum) (memq datum (cdr datalist)))               ; (append!) doesn't like empty lists?!
            ((list? datum) (member datum (cdr datalist)))
            (else (error "Unknown data type -- IS-IN-DATALIST?" entry))
        )
      )
      (define (add-to-datalist! entry datalist)
        (if (not (is-in-datalist? entry datalist))
            (append! datalist (list entry))
        )
        'done
      )            
      (define (dispatch message)
        (cond ((eq? message 'start)                                    
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)             
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)     
              ((eq? message 'get-register) lookup-register)            
              ((eq? message 'install-operations)                       
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)                             
              ((eq? message 'operations) the-ops)                      
              
              ((eq? message 'print-datalists) (print-datalists))        ; <---- new messages to provide access to the new information
              ((eq? message 'log-entry) add-to-entry-datalist!)
              ((eq? message 'log-save) add-to-save-datalist!)
              ((eq? message 'log-restore) add-to-restore-datalist!)
              
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))
      
; modified for case b.
(define (make-goto-5.12 inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg
                  (get-register machine
                                (register-exp-reg dest))))
             ((machine 'log-entry) (register-exp-reg dest))             ; <---- new logging code (just 1 line)
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))
                       
; modified for case c
(define (make-save-5.12 inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    ((machine 'log-save) (stack-inst-reg-name inst))                    ; <---- new logging code (1 line)
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore-5.12 inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    ((machine 'log-restore) (stack-inst-reg-name inst))                 ; <---- new logging code (1 line)
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))

      
      
; -------------------------------------------------------------------------
      
      
(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")

; overrides
(define make-new-machine make-new-machine-5.12) 
(define make-goto make-goto-5.12)
(define make-save make-save-5.12)
(define make-restore make-restore-5.12)

(define fib-machine (make-fib-machine-5.6))
(fib-machine 'print-datalists)
