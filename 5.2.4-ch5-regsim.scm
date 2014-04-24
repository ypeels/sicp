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
    dispatch))

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
        (number-pushes 0)
        (max-depth 0)
        (current-depth 0))
    (define (push x)
      (set! s (cons x s))
      (set! number-pushes (+ 1 number-pushes))
      (set! current-depth (+ 1 current-depth))
      (set! max-depth (max current-depth max-depth)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            (set! current-depth (- current-depth 1))
            top)))    
    (define (initialize)
      (set! s '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done)
    (define (print-statistics)
      (newline)
      (display (list 'total-pushes  '= number-pushes
                     'maximum-depth '= max-depth)))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            ((eq? message 'print-statistics)
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
                 (list 'print-stack-statistics
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

(define (assemble controller-text machine)
  (extract-labels controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (receive insts
                        (cons (make-label-entry next-inst
                                                insts)
                              labels))
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels)))))))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc! 
        inst
        (make-execution-procedure
         (instruction-text inst) labels machine
         pc flag stack ops)))
     insts)))

(define (make-instruction text)
  (cons text '()))

(define (instruction-text inst)
  (car inst))

(define (instruction-execution-proc inst)
  (cdr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-cdr! inst proc))

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        (cdr val)
        (error "Undefined label -- ASSEMBLE" label-name))))


(define (make-execution-procedure inst labels machine
                                  pc flag stack ops)
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


(define (make-assign inst machine labels operations pc)
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

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((condition-proc
               (make-operation-exp
                condition machine labels operations)))
          (lambda ()
            (set-contents! flag (condition-proc))
            (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (test-condition test-instruction)
  (cdr test-instruction))


(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
    (if (label-exp? dest)
        (let ((insts
               (lookup-label labels (label-exp-label dest))))
          (lambda ()
            (if (get-contents flag)
                (set-contents! pc insts)
                (advance-pc pc))))
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (branch-dest branch-instruction)
  (cadr branch-instruction))


(define (make-goto inst machine labels pc)
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
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
        (let ((action-proc
               (make-operation-exp
                action machine labels operations)))
          (lambda ()
            (action-proc)
            (advance-pc pc)))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define (perform-action inst) (cdr inst))

(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
         (let ((c (constant-exp-value exp)))
           (lambda () c)))
        ((label-exp? exp)
         (let ((insts
                (lookup-label labels
                              (label-exp-label exp))))
           (lambda () insts)))
        ((register-exp? exp)
         (let ((r (get-register machine
                                (register-exp-reg exp))))
           (lambda () (get-contents r))))
        (else
         (error "Unknown expression type -- ASSEMBLE" exp))))

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))


(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (lambda (e)
                (make-primitive-exp e machine labels))
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))

(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)
  (cdr operation-exp))


(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
    (if val
        (cadr val)
        (error "Unknown operation -- ASSEMBLE" symbol))))

;; from 4.1
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

'(REGISTER SIMULATOR LOADED)
