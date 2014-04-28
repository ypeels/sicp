;;;;REGISTER-MACHINE SIMULATOR FROM SECTION 5.2 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;Then you can define and simulate machines as shown in section 5.2

;;;**NB** there are two versions of make-stack below.
;;; Choose the monitored or unmonitored one by reordering them to put the
;;;  one you want last, or by commenting one of them out.
;;; Also, comment in/out the print-stack-statistics op in make-new-machine
;;; To find this stack code below, look for comments with **


(define (make-machine register-names ops controller-text)               ; API procedure 1 of 4
  (let ((machine (make-new-machine)))                                       ; construct empty basic machine model - to which you PASS MESSAGES
    (for-each (lambda (register-name)                                       ; allocate the requested registers
                ((machine 'allocate-register) register-name))
              register-names)
    ((machine 'install-operations) ops)                                     ; install the designated operations
    ((machine 'install-instruction-sequence)                                ; install the machine's instruction sequence...
     (assemble controller-text machine))                                    ; as output by the ASSEMBLER (5.2.2)
    machine))                                                               ; return value: the modified machine model, ready to (set!)/(start).

(define (make-register name)                                            ; ONLY called from (make-new-machine): represent a register as a procedure with local state
  (let ((contents '*unassigned*))                                           ; register value that can be...
    (define (dispatch message)
      (cond ((eq? message 'get) contents)                                   ; accessed or...
            ((eq? message 'set)
             (lambda (value) (set! contents value)))                        ; changed
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))                                                              ; n.b. register name is thrown away!! left as an exercise for 5.2.4?

(define (get-contents register)                                         ; register API: syntactic sugar
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

;;**original (unmonitored) version from section 5.2.1
(define (make-stack)                                                    ; ONLY called from (make-new-machine): also represent a stack as a procedure with local state
  (let ((s '()))
    (define (push x)                                                        ; push an item onto the stack
      (set! s (cons x s)))
    (define (pop)                                                           ; pop the top item off the stack and return it
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            top)))
    (define (initialize)                                                    ; initialize the stack to empty
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

;;**monitored version from section 5.2.4
(define (make-stack)                                                    ; ONLY called from (make-new-machine)
  (let ((s '())
        (number-pushes 0)                                                   ; 3 additional state variables for monitoring
        (max-depth 0)
        (current-depth 0))
    (define (push x)
      (set! s (cons x s))
      (set! number-pushes (+ 1 number-pushes))                              ; 3 additional assignments 
      (set! current-depth (+ 1 current-depth))                                  ; current-depth is only used internally by max-depth
      (set! max-depth (max current-depth max-depth)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            (set! current-depth (- current-depth 1))                        ; 1 additional assignment (pop doesn't affect # pushes or max depth)
            top)))    
    (define (initialize)
      (set! s '())
      (set! number-pushes 0)                                                ; 3 additional initializations
      (set! max-depth 0)
      (set! current-depth 0)
      'done)
    (define (print-statistics)                                              ; new function! 
      (newline)
      (display (list 'total-pushes  '= number-pushes                            ; display state variables (current-depth is not printed)
                     'maximum-depth '= max-depth)))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            ((eq? message 'print-statistics)                                ; dispatch for new function
             (print-statistics))
            (else
             (error "Unknown request -- STACK" message))))
    dispatch))

(define (make-new-machine)                                              ; ONLY called from (make-machine)
  (let ((pc (make-register 'pc))                                            ; Program Counter determines instruction sequence as implemented by (execute)
        (flag (make-register 'flag))                                        ; flag controls branching (contains result of TEST instructions)
        (stack (make-stack))
        (the-instruction-sequence '()))                                     ; initially empty instruction sequence.
    (let ((the-ops                                                          ; local operation list - initialized with stack manipulation utilities
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))                         ; binds stack, hence the nested (let)
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics                              ; added in 5.2.4 for stack statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table                                                   ; local register table - initialized with all default registers
           (list (list 'pc pc) (list 'flag flag))))                             ; binds pc and flag, hence the nested (let)
      (define (allocate-register name)                                      ; adds new entries to the register table
        (if (assoc name register-table)                                         ; this procedure is ONLY invoked by message passing in (make-machine)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)                                        ; looks up registers in the [register] table
        (let ((val (assoc name register-table)))                                ; invoked by (get-register), which is called in MANY places. 
          (if val                                                               ; this means many places are modifying raw registers directly...
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))                                    ; pc points to the next instruction to be executed
          (if (null? insts)
              'done
              (begin                                                        ; each machine instruction includes a procedure of no arguments, called the instruction execution procedure...
                ((instruction-execution-proc (car insts)))                  ; calling this procedure simulates executing the instruction
                (execute)))))                                                   ; [and i guess it will update pc too, before the recursion?]
      (define (dispatch message)
        (cond ((eq? message 'start)                                         ; only invoked by public API procedure (start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)                  ; only invoked by message passing in (make-machine)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)          ; only invoked by message passing in (make-machine)
              ((eq? message 'get-register) lookup-register)                 ; used extensively via (get-register)?
              ((eq? message 'install-operations)                            ; only invoked by message passing in (make-machine)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)                                  ; only invoked by message passing in (update-insts!)?
              ((eq? message 'operations) the-ops)                           ; only invoked by message passing in (update-insts!)?
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))


(define (start machine)                                                 ; the other 3 API procedures (convenience functions, really)
  (machine 'start))

(define (get-register-contents machine register-name)                       ; syntactic sugar/convenience procedure to READ from register in machine
  (get-contents (get-register machine register-name)))

(define (set-register-contents! machine register-name value)                ; syntactic sugar/convenience procedure to WRITE to register in machine
  (set-contents! (get-register machine register-name) value)
  'done)

(define (get-register machine reg-name)                                     ; pull a raw register right out of the machine. breaks encapsulation?
  ((machine 'get-register) reg-name))
                                            ; ------------ 5.2.2: The assembler transforms the sequence of controller expressions for a machine into a corresponding list of machine instructions, each with its execution procedure
(define (assemble controller-text machine)                              ; ONLY invoked from (make-machine) - the main entry to the assembler.
  (extract-labels controller-text                                           ; build initial instruction list and label table
    (lambda (insts labels)                                                  ; a procedure to be called to process these results
      (update-insts! insts labels machine)                                      ; insts = running MACHINE instruction list, labels = running label list (only used internally, and not returned)
      insts)))                                                              ; returns instruction sequence to be stored in machine 

(define (extract-labels text receive)                                   ; ONLY invoked from (assemble): text = raw instruction list, receive = procedure
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)                                            ; will recurse to the rest of text
       (lambda (insts labels)                                               ; receive function, really updated just to build up DATA iteratively... such is the price of recursing a higher order function.
         (let ((next-inst (car text)))                                      ; but first, process next-inst(ruction)
           (if (symbol? next-inst)                                          ; if the element is a symbol (and thus a label)...
               (receive insts                                                   
                        (cons (make-label-entry next-inst                       ; an appropriate entry is added to the labels table
                                                insts)                          ; [building it up from RIGHT TO LEFT, since "insts" and "labels" come from the NEXT RECURSION. i can't WAIT to be done with this book, and with Lisp...]
                              labels))                                              ; currently, insts = pointer to REST OF INSTRUCTION LIST [i.e., supports multiple labels]
               (receive (cons (make-instruction next-inst)                      ; otherwise the element is accumulated onto the insts list
                              insts)                                        ; Footnote 4: effectively return two values -- labels and insts -- without explicitly making a compound data structure to hold them.
                        labels)))))))                                           ; "an excuse to show off a programming trick." - technically a continuoation, like in 4.3.3 for ambeval.

(define (update-insts! insts labels machine)                            ; ONLY invoked from (assemble) - appends execution procedures to instruction list
  (let ((pc (get-register machine 'pc))                                     ; executed AFTER (extract-labels) has fully completed
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each                                                               
     (lambda (inst)
       (set-instruction-execution-proc!                                     ; simply pairs the instruction text with the corresponding execution procedure
        inst
        (make-execution-procedure                                           ; 5.2.3: the heart of the assembler
         (instruction-text inst) labels machine
         pc flag stack ops)))
     insts)))

(define (make-instruction text)                                         ; only invoked from (extract-labels)
  (cons text '()))                                                          ; cdr will be modified by (update-insts!) -> (set-instruction-execution-proc!)

(define (instruction-text inst)                                         ; only invoked from (update-insts!)
  (car inst))                                                               ; The instruction text is not used by our simulator, but it is handy to keep around for debugging (see exercise 5.16).

(define (instruction-execution-proc inst)                               ; only invoked from machine's (execute)
  (cdr inst))                                                               ; retrieve machine instruction just prior to executing it.

(define (set-instruction-execution-proc! inst proc)                     ; ONLY invoked from (update-insts!)
  (set-cdr! inst proc))                                                     ; inst = (text . '()) from (make-instruction)

(define (make-label-entry label-name insts)                             ; only invoked from (extract-labels)
  (cons label-name insts))                                                  ; insts = pointer to rest of instruction list

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        (cdr val)
        (error "Undefined label -- ASSEMBLE" label-name))))

                                            ; ------------ 5.2.3: Generating Execution Procedures for Instructions
(define (make-execution-procedure inst labels machine                   ; ONLY invoked from (update-insts!)
                                  pc flag stack ops)                        ; generate the execution procedure for an instruction.
  (cond ((eq? (car inst) 'assign)                                           ; supports instruction list from p. 513
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))                       ; The details of these procedures determine both the syntax and 
        ((eq? (car inst) 'branch)                                           ; meaning of the individual instructions in the register-machine language.
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)                                             ; they were a BIT lazy and didn't write (goto? inst), etc.
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))


(define (make-assign inst machine labels operations pc)                 ; only invoked from (make-execution-procedure)
  (let ((target
         (get-register machine (assign-reg-name inst)))                     ; extract target register name - done only once, at assembly time.
        (value-exp (assign-value-exp inst)))                                ; extract value expression
    (let ((value-proc                                                       ; (assign <reg name> <value>)
           (if (operation-exp? value-exp)
               (make-operation-exp                                          ; p. 513: <value> = (op <name2>) <input1> ... <inputN>, or...
                value-exp machine labels operations)
               (make-primitive-exp                                              ; (reg <name2>) or (const <name2>)
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign            ; the machine instruction to be evaluated in machine's (execute)
        (set-contents! target (value-proc))                                     ; opcode = set-contents!, target = register, and EVALUATE (value-proc)
        (advance-pc pc)))))

(define (assign-reg-name assign-instruction)                                
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))                 

(define (advance-pc pc)                                                 ; <=== the normal termination for all instructions except branch and goto
  (set-contents! pc (cdr (get-contents pc))))                               ; pc = pointer to instruction list

(define (make-test inst machine labels operations flag pc)              ; only invoked from (make-execution-procedure). similar [to make-assign]
  (let ((condition (test-condition inst)))                                  ; extracts expression specifying the condition to be tested...
    (if (operation-exp? condition)
        (let ((condition-proc
               (make-operation-exp                                          ; and generates an execution procedure for it
                condition machine labels operations)))
          (lambda ()
            (set-contents! flag (condition-proc))                           ; at simulation time, result is assigned to the flag register
            (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (test-condition test-instruction)                                   ; (test (op <op-name>) <input1> ... <inputN>)
  (cdr test-instruction))


(define (make-branch inst machine labels flag pc)                       ; only invoked from (make-execution-procedure)
  (let ((dest (branch-dest inst)))                                          ; uses (lookup-label) from 5.2.2 and (label-exp-label) from below.
    (if (label-exp? dest)
        (let ((insts                                                        ; insts = pointer to inst list starting at label.
               (lookup-label labels (label-exp-label dest))))               ; branch destination must be a label; looked up at ASSEMBLY time. 
          (lambda ()                                                        ; the execution procedure for a branch instruction...
            (if (get-contents flag)                                         ; checks the contents of the flag register and either...
                (set-contents! pc insts)                                    ; jumps to the branch destination...
                (advance-pc pc))))                                          ; or else just advances the pc
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (branch-dest branch-instruction)                                    ; (branch (label <label-name>))
  (cadr branch-instruction))


(define (make-goto inst machine labels pc)                              ; only invoked from (make-execution-procedure)
  (let ((dest (goto-dest inst)))                                            ; similar to a branch...
    (cond ((label-exp? dest)                                                ; except that the destination may be specified either as a label...
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)                                             ; or a register [e.g., (save/restore continue)]...
           (let ((reg
                  (get-register machine
                                (register-exp-reg dest))))
             (lambda ()                                                     ; and there is no condition to check
               (set-contents! pc (get-contents reg)))))                     ; [execution procedures are unconditional]
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))

(define (goto-dest goto-instruction)                                        ; (goto (label <name>)) or (goto (reg <name>))
  (cadr goto-instruction))

(define (make-save inst machine stack pc)                               ; only invoked from (make-execution-procedure)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg))                                       ; simply use the stack with the designated register
      (advance-pc pc))))                                                    ; (push) from 5.2.1 (or monitored version from 5.2.4)

(define (make-restore inst machine stack pc)                            ; only invoked from (make-execution-procedure)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack))                                       ; the inverse of the execution procedure for (save)
      (advance-pc pc))))

(define (stack-inst-reg-name stack-instruction)                             ; (save <register-name>) and (restore <register-name>)
  (cadr stack-instruction))

(define (make-perform inst machine labels operations pc)                ; only invoked from (make-execution-procedure)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
        (let ((action-proc
               (make-operation-exp
                action machine labels operations)))
          (lambda ()                                                        ; execution procedure for the action to be performed
            (action-proc)
            (advance-pc pc)))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define (perform-action inst) (cdr inst))                                   ; (perform (op <name>) <input1> ... <inputN>)

(define (make-primitive-exp expr machine labels)                        ; only invoked by (make-assign) or (make-operation-exp)
  (cond ((constant-exp? expr)                                               ; execution procedures that produce values for...
         (let ((c (constant-exp-value expr)))
           (lambda () c)))                                                  ; constants,
        ((label-exp? expr)
         (let ((insts
                (lookup-label labels
                              (label-exp-label expr))))
           (lambda () insts)))                                              ; labels - pc pointer value via (lookup-label), 
        ((register-exp? expr)
         (let ((r (get-register machine
                                (register-exp-reg expr))))
           (lambda () (get-contents r))))                                   ; and registers
        (else
         (error "Unknown exprression type -- ASSEMBLE" expr))))

(define (register-exp? expr) (tagged-list? expr 'reg))                  ; these determine the syntax of reg, label, and const expressions
                                                                            ; an ordering consistent with (make-primitive-exp) would have been nice...
(define (register-exp-reg expr) (cadr expr))                                ; (reg <name-without-whitespace>)

(define (constant-exp? expr) (tagged-list? expr 'const))

(define (constant-exp-value expr) (cadr expr))                              ; (const <value>)

(define (label-exp? expr) (tagged-list? expr 'label))

(define (label-exp-label expr) (cadr expr))                                 ; (label <name-without-whitespace>)


(define (make-operation-exp expr machine labels operations)             ; only invoked from (make-assign), (make-test), and (make-perform)
  (let ((op (lookup-prim (operation-exp-op expr) operations))               
        (aprocs                                                             ; aprocs = execution procedures for individual arguments
         (map (lambda (e)                                                       ; cf. (analyze-application) from 4.1.7 p. 397
                (make-primitive-exp e machine labels))                      ; arguments are PRESUMED to be primitive
              (operation-exp-operands expr))))
    (lambda ()                                                              ; execution procedure for (op <arg1> ... <argN>)
      (apply op (map (lambda (p) (p)) aprocs)))))                           ; get value of EVERY argument, then apply op to values

(define (operation-exp? expr)                                           ; these determine the syntax of operation expressions
  (and (pair? expr) (tagged-list? (car expr) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)                              ; ((op <op-name>) <input1> ... <inputN>)
  (cdr operation-exp))


(define (lookup-prim symbol operations)                                 ; ONLY invoked from (make-operation-exp)
  (let ((val (assoc symbol operations)))                                    ; operations = ('op op) table all the way from (make-[new]-machine)
    (if val
        (cadr val)
        (error "Unknown operation -- ASSEMBLE" symbol))))

;; from 4.1
(define (tagged-list? expr tag)
  (if (pair? expr)
      (eq? (car expr) tag)
      false))

'(REGISTER SIMULATOR LOADED)
