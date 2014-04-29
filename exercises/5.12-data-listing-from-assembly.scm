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
    (define (make-empty-datalist sym)                                   ; new helper function
        (list                                                               ; not init to '() because of (append!) quirk...?
            (string->symbol                                                 ; would set! + cons work better? meh
                (string-append
                    "*"
                    (symbol->string sym)
                    "-datalist*"
                )
            )
        )
    )

                                            
  (let ((pc (make-register 'pc))                                       
        (flag (make-register 'flag))                                   
        (stack (make-stack))
        (the-instruction-sequence '())
        (entry-datalist (make-empty-datalist 'entry))                            ; <---- new data structures
        (save-datalist (make-empty-datalist 'save))        
        (restore-datalist (make-empty-datalist 'restore))
        (instruction-datalist-table 
            (list
                (cons 'assign (make-empty-datalist 'assign))
                (cons 'branch (make-empty-datalist 'branch))
                (cons 'goto (make-empty-datalist 'goto))
                (cons 'perform (make-empty-datalist 'perform))
                (cons 'restore (make-empty-datalist 'restore))
                (cons 'save (make-empty-datalist 'save))
                (cons 'test (make-empty-datalist 'test))
            )                
        )
        (assign-datalist-table                                                  ; could also put in the next let... but this keeps all datalists together
            (list
                (cons 'pc (make-empty-datalist 'pc))
                (cons 'flag (make-empty-datalist 'flag))                        
            )
        )
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
            (begin
                (set! assign-datalist-table                                     ; <---- new: add new register to register-datalist-table
                      (cons
                        (list name (make-empty-datalist name))
                        assign-datalist-table))
                (set! register-table
                      (cons (list name (make-register name))
                            register-table));)
            )
        )
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
        (define (print-single-datalist datalist title)
            (newline)
            (display title)
            (newline)
            (display (cdr datalist))
            (newline)
        )
        (define (print-datalist-table table title)
            (for-each 
                (lambda (datalist) 
                    (print-single-datalist datalist title))
                table
            )
        )
        
        (print-single-datalist entry-datalist "Registers used by (goto)")
        (print-single-datalist save-datalist "Registers used by (save)")
        (print-single-datalist restore-datalist "Registers used by (restore)")
        (print-datalist-table assign-datalist-table "Assignments")
        ;(display assign-datalist-table)
        ;(print-datalist-table instruction-datalist-table "Instructions")
        (for-each
            (lambda (datalist) (newline) (display datalist))
            instruction-datalist-table) ; otherwise it's just too cluttered
            
      
        ;(display "\n\nRegisters used by (goto)\n")
        ;(display (cdr entry-datalist))
        ;(display "\n\nRegisters used by (save)\n")
        ;(display (cdr save-datalist))
        ;(display "\n\nRegisters used by (restore)\n")
        ;(display (cdr restore-datalist))
        ;(display "\n\nRegister data sources\n")
      )
      
      ; single-datalist functions
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
            (else (error "Unknown data type -- IS-IN-DATALIST?" datum))
        )
      )
      (define (add-to-datalist! datum datalist)
        (if (not (is-in-datalist? datum datalist))
            (append! datalist (list datum))
        )
        'done
      )            
      
      ; datalist table functions. figuring out my data structures was 90% of the battle
      (define (get-datalist-from-table name table)
        (let ((datalist (assoc name table)))
            (if datalist
                datalist
                (error "Datalist not found -- GET-DATALIST-FROM-TABLE" name table)
            )
        )
      )
      
      (define (add-to-assign-datalists! register-name value-exp)
        (let ((datalist (get-datalist-from-table register-name assign-datalist-table)))
            (add-to-datalist! value-exp datalist)
        )
      )      
      (define (add-to-instruction-datalists! instruction-type expr)
        ;(display instruction-type)(newline)
        ;(display expr)(newline)(newline)
        (let ((datalist (get-datalist-from-table instruction-type instruction-datalist-table)))
            (add-to-datalist! instruction-type expr)
        )
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
              ((eq? message 'log-assign) add-to-assign-datalists!)
              ((eq? message 'log-instruction) add-to-instruction-datalists!)
              
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
      
; modified for case d
(define (make-assign-5.12 inst machine labels operations pc)   
  ((machine 'log-assign) (assign-reg-name inst) (assign-value-exp inst))
  (let ((target
         (get-register machine (assign-reg-name inst)))             
        (value-exp (assign-value-exp inst)))                        
    (let ((value-proc                                               
           (if (operation-exp? value-exp)
               (make-operation-exp                                  
                value-exp machine labels operations)
               (make-primitive-exp                                  
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign    
        (set-contents! target (value-proc))                         
        (advance-pc pc)))))
        
; modified for case a
(define (make-execution-procedure-5.12 inst labels machine         
                                  pc flag stack ops)  
  ;((machine 'log-instruction) (car inst) (cdr inst))                    ; <---- new logging code (1 line)
  ;(display (car inst)) (newline)
  (cond ((eq? (car inst) 'assign)                             
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))         
        ((eq? (car inst) 'branch)                             
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)                               
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))      
      
; -------------------------------------------------------------------------
      
      
(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")

; overrides
(define make-new-machine make-new-machine-5.12) 
(define make-goto make-goto-5.12)
(define make-save make-save-5.12)
(define make-restore make-restore-5.12)
(define make-assign make-assign-5.12)
(define make-execution-procedure make-execution-procedure-5.12)

(define fib-machine (make-fib-machine-5.6))

; regression test
(test-5.6-long)

; test new functionality
(fib-machine 'print-datalists)

