;;;;COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;**NOTE**This file loads the metacircular evaluator's syntax procedures
;;;;  from section 4.1.2
;;;;  You may need to change the (load ...) exprression to work in your
;;;;  version of Scheme.

;;;;Then you can compile Scheme programs as shown in section 5.5.5

;;**implementation-dependent loading of syntax procedures
(load "ch5-syntax.scm")			;section 4.1.2 syntax procedures


;;;SECTION 5.5.1                                                ; <==== 5.5.1: Structure of the Compiler
                                                               
(define (compile expr target linkage)                               ; top-level dispatch, corresponding to (eval), (analyze), and eval-dispatch 
  (cond ((self-evaluating? expr)                                        ; again uses expression-syntax procedures from 4.1.2 
         (compile-self-evaluating expr target linkage))
        ((quoted? expr) (compile-quoted expr target linkage))       ; Targets and linkages, p. 571    
        ((variable? expr)                                               ; target = register in which compiled code returns value of expression
         (compile-variable expr target linkage))                        ; linkage = describes how to proceed after compiled code has executed
        ((assignment? expr)                                                 ; "next": continue at next instruction in sequence
         (compile-assignment expr target linkage))                          ; "return": return from procedure being compiled
        ((definition? expr)                                                 ; <label>: jump to a named entry point
         (compile-definition expr target linkage))
        ((if? expr) (compile-if expr target linkage))
        ((lambda? expr) (compile-lambda expr target linkage))       ; "code generators"
        ((begin? expr)
         (compile-sequence (begin-actions expr)
                           target
                           linkage))
        ((cond? expr) (compile (cond->if expr) target linkage))
        ((application? expr)
         (compile-application expr target linkage))
        (else
         (error "Unknown exprression type -- COMPILE" expr))))


(define (make-instruction-sequence needs modifies statements)       ; p. 573: An instruction sequence will contain three pieces of information:
  (list needs modifies statements))                                     ; needs: registers [to be READ] that must be initialized before instructions are executed
                                                                        ; modifies: registers [to be WRITTEN] whose values are modified by instructions
(define (empty-instruction-sequence)                                    ; statements: the actual instructions
  (make-instruction-sequence '() '() '()))                              ; the first 2 are used by (append-instruction-sequences) and (preserving) - 5.5.4 code below


;;;SECTION 5.5.2                                            ; <==== 5.5.2: Compiling Expressions

;;;linkage code                                                 ; Compiling linkage code

(define (compile-linkage linkage)                                   ; "In general, the output of each code generator will end" with this.
  (cond ((eq? linkage 'return)
         (make-instruction-sequence '(continue) '()                     ; return: needs continue, modifies none.
          '((goto (reg continue)))))
        ((eq? linkage 'next)
         (empty-instruction-sequence))                                  ; next: do nothing!
        (else
         (make-instruction-sequence '() '()
          `((goto (label ,linkage)))))))                                ; else: goto linkage. for backquote syntax, see Footnote 36.

(define (end-with-linkage linkage instruction-sequence)             ; append linkage to an instruction sequence (not ALWAYS done! see below)
  (preserving '(continue)                                               ; preserve continue, if ...
   instruction-sequence                                                 ; the given instruction sequence modifies it and...
   (compile-linkage linkage)))                                          ; the linkage code needs it (return linkage)


;;;simple exprressions                                          ; Compiling simple expressions

(define (compile-self-evaluating expr target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)                     ; Assign the required value to the target register [argument]...
    `((assign ,target (const ,expr))))))                                ; [don't want a literal "target" INSIDE the quote!]

(define (compile-quoted expr target linkage)
  (end-with-linkage linkage                                         ; and then proceed as specified by the linkage descriptor [argument].
   (make-instruction-sequence '() (list target)                     ; All these instructions will modify the target register...
    `((assign ,target (const ,(text-of-quotation expr)))))))            ; [the compiler can bake in quotation text instead of using reg val!]

(define (compile-variable expr target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '(env) (list target)                  ; and the one that looks up a variable needs the env register.
    `((assign ,target
              (op lookup-variable-value)
              (const ,expr)                                             ; [the compiler can bake in variable names instead of using reg val!]
              (reg env))))))

(define (compile-assignment expr target linkage)                    ; Assignments and definitions are handled much as they are in the interpreter.
  (let ((var (assignment-variable expr))
        (get-value-code                                                 ; generate code that computes the value to be assigned to the variable,
         (compile (assignment-value expr) 'val 'next)))                     ; [with target val and linkage next for appending]
    (end-with-linkage linkage
     (preserving '(env)                                                     ; [save env for set! to modify - since get-value-code might trash it]
      get-value-code                                                    ; and append to it...
      (make-instruction-sequence '(env val) (list target)               ; a two-instruction sequence...
       `((perform (op set-variable-value!)                              ; that actually sets/defines the variable...
                  (const ,var)
                  (reg val)                                                 ; [using the result val from get-value-code]
                  (reg env))
         (assign ,target (const ok))))))))                              ; and returns 'ok in the target register.

(define (compile-definition expr target linkage)
  (let ((var (definition-variable expr))
        (get-value-code
         (compile (definition-value expr) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       `((perform (op define-variable!)                                 ; <--- the only difference with (compile-assignment).        
                  (const ,var)
                  (reg val)
                  (reg env))
         (assign ,target (const ok))))))))


;;;conditional exprressions                                     ; Compiling conditional expressions
                                                                    
;;;labels (from footnote)                                           ; Footnote 37 p. 578: generate labels that are unique within the object code
(define label-counter 0)                                                ; cf. unique query variable names - pp. 477, 486 Secs 4.4.4.4 and 4.4.4.7
                                                                    ; code skeleton p. 577
(define (new-label-number)                                          ;  <compiled predicate, target val, linkage next>
  (set! label-counter (+ 1 label-counter))                          ;  (test (op false?) (reg val))
  label-counter)                                                    ;  (branch (label false-branch))
                                                                    ; true-branch
(define (make-label name)                                           ;  <compiled consequent with given target and given linkage or after-if> [need after-if if given linkage = next]
  (string->symbol                                                   ; false-branch
    (string-append (symbol->string name)                            ;  <compilation of alternative with given target and linkage>
                   (number->string (new-label-number)))))           ; after-if
;; end of footnote

(define (compile-if expr target linkage)
  (let ((t-branch (make-label 'true-branch))
        (f-branch (make-label 'false-branch))                    
        (after-if (make-label 'after-if)))
    (let ((consequent-linkage                                       ; if linkage = return or label, true uses it directly
           (if (eq? linkage 'next) after-if linkage)))                  ; but for linkage = next, jump around false code to after-if
      (let ((p-code (compile (if-predicate expr) 'val 'next))       ; compile the predicate, consequent, and alternative
            (c-code
             (compile
              (if-consequent expr) target consequent-linkage))
            (a-code
             (compile (if-alternative expr) target linkage)))
        (preserving '(env continue)                                 ; env might be needed by c-code/a-code, continue by linkage
         p-code
         (append-instruction-sequences
          (make-instruction-sequence '(val) '()
           `((test (op false?) (reg val))                           ; test the predicate result, with newly-inserted labels
             (branch (label ,f-branch))))
          (parallel-instruction-sequences                           ; special combiner from 5.5.4: instructions in parallel
           (append-instruction-sequences t-branch c-code)               ; (no need for preserving between them)
           (append-instruction-sequences f-branch a-code))
          after-if))))))

;;; sequences                                                   ; Compiling sequences

(define (compile-sequence seq target linkage)                       ; parallels ev-sequence
  (if (last-exp? seq)                                                   
      (compile (first-exp seq) target linkage)                          ; last expression with (final) linkage for the sequence
      (preserving '(env continue)                                           ; env needed for rest of seq, continue (possibly) for final linkage
       (compile (first-exp seq) target 'next)                           ; other expressions with linkage next (to rest of sequence)
       (compile-sequence (rest-exps seq) target linkage))))

;;;lambda exprressions                                          ; Compiling lambda expressions

(define (compile-lambda expr target linkage)                        ; code to construct procedure object; followed by code for procedure body    
  (let ((proc-entry (make-label 'entry))                                
        (after-lambda (make-label 'after-lambda)))                      ; hmm, generates label before it knows it's necessary...
    (let ((lambda-linkage                                               
           (if (eq? linkage 'next) after-lambda linkage)))              ; need to skip body if linkage is next (return or goto proceeds normally)
      (append-instruction-sequences                                     
       (tack-on-instruction-sequence                                    ; special combiner from 5.5.4 (2nd seq not executed)
        (end-with-linkage lambda-linkage                                
         (make-instruction-sequence '(env) (list target)                
          `((assign ,target                                             ; <construct procedure object and assign it to target register>
                    (op make-compiled-procedure)                            ; new op - Footnote 38 p. 580
                    (label ,proc-entry)                                     ; proc body entry point + current env (SAVED from point of definition) - p. 580
                    (reg env)))))                                       ; <lambda-linkage> - from (end-with-linkage)
        (compile-lambda-body expr proc-entry))                          ; <compiled body> - from (tack-on-instruction-sequence)
       after-lambda))))                                                 ; label after-lambda - from (append-instruction-sequences)

(define (compile-lambda-body expr proc-entry)                       ; code for body [since we're already here]
  (let ((formals (lambda-parameters expr)))                             ; ONLY invoked from (compile-lambda).
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
      `(,proc-entry                                                     ; label for entry point (for application)
        (assign env (op compiled-procedure-env) (reg proc))             ; the definition env of the procedure...
        (assign env
                (op extend-environment)                                     ; extended to include bindings of arguments
                (const ,formals)
                (reg argl)
                (reg env))))
     (compile-sequence (lambda-body expr) 'val 'return))))              ; The procedure body.
                                                                        ; Always end with return(val).

;;;SECTION 5.5.3                                            ; <==== 5.5.3: Compiling Combinations [i.e., procedure applications - p. 6!]       

;;;combinations

(define (compile-application expr target linkage)               ; "The essence of the compilation process is the compilation of procedure applications."
  (let ((proc-code (compile (operator expr) 'proc 'next))           ; <---- the only place where target != val in the compiler
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands expr))))
    (preserving '(env continue)                                         ; env needed for operands, continue for final linkage
     proc-code                                                      ; <compilation of operator, target proc, linkage next>
     (preserving '(proc continue)                                       ; proc needed for final application, continue for final linkage
      (construct-arglist operand-codes)                             ; <evaluate operands and construct argument list in argl>
      (compile-procedure-call target linkage)))))                   ; <compilation of procedure call with given target and linkage>

(define (construct-arglist operand-codes)                       ; ONLY invoked from (compile-application). "tricky, because of the special treatment of the first operand to be evaluated"
  (let ((operand-codes (reverse operand-codes)))                    ; build up argl using cons, so start with the last arg
    (if (null? operand-codes)                                       ; operand-codes = (reversed) list of compiled operands
        (make-instruction-sequence '() '(argl)                      
         '((assign argl (const ()))))                               ; no arguments, so argl = '(). handled as a special case, "rather than [always] waste an an instruction by initializing argl to the empty list"
        (let ((code-to-get-last-arg
               (append-instruction-sequences                        ; argl construction skeleton p. 582
                (car operand-codes)                                     ; <compilation of last operand, targeted to val>
                (make-instruction-sequence '(val) '(argl)
                 '((assign argl (op list) (reg val)))))))               ; (assign argl (op list) (reg val))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)                                            ; preserve env for subsequent operand evaluations
               code-to-get-last-arg
               (code-to-get-rest-args                                   ; *<compilation of next operand, targeted to val>
                (cdr operand-codes))))))))                              ; **(assign argl (op cons) (reg val) (reg argl)) below

(define (code-to-get-rest-args operand-codes)                   ; ONLY invoked from (construct-arglist)
  (let ((code-for-next-arg
         (preserving '(argl)                                        ; operand code might trash argl!
          (car operand-codes)                                       ; * above
          (make-instruction-sequence '(val argl) '(argl)
           '((assign argl                                           ; ** above
              (op cons) (reg val) (reg argl)))))))
    (if (null? (cdr operand-codes))                                 ; if this is the last arg (in the reversed list)
        code-for-next-arg                                               ; then we are done!
        (preserving '(env)                                              ; otherwise, save the env...
         code-for-next-arg
         (code-to-get-rest-args (cdr operand-codes))))))                ; for evaluating the next operand.

;;;applying procedures                                          ; Applying procedures - cf. (apply) from 4.1.1 p. 366 or apply-dispatch from 5.4.1 p. 553
                                                                    ; precondition: proc = operator value, argl = operand values
(define (compile-procedure-call target linkage)                     ; ONLY invoked from (compile-application)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage                                         ; cf. linkage for true-branch for compile-if
           (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()                       ; skeleton p. 584
        `((test (op primitive-procedure?) (reg proc))               ; (test (op primitive-procedure?) (reg proc))
          (branch (label ,primitive-branch))))                      ; (branch (label ,primitive-branch))
       (parallel-instruction-sequences                                  ; special combiner like with if
        (append-instruction-sequences
         compiled-branch                                            ; compiled-branch [next-linkage skips primitive-branch]
         (compile-proc-appl target compiled-linkage))               ; <code to apply compiled procedure with given target and appropriate linkage>
        (append-instruction-sequences
         primitive-branch                                           ; primitive-branch
         (end-with-linkage linkage
          (make-instruction-sequence '(proc argl)
                                     (list target)
           `((assign ,target                                        ; (assign <target> (op apply-primitive-procedure) (reg proc) (reg argl))
                     (op apply-primitive-procedure)
                     (reg proc)
                     (reg argl)))))))                               ; <linkage> [argument - from (end-with-linkage)]
       after-call))))                                               ; after-call

;;;applying compiled procedures                                 ; Applying compiled procedures
                                                                    ; "the most subtle part of the compiler"
(define (compile-proc-appl target linkage)                          ; ONLY invoked from (compile-procedure-call)
  (cond ((and (eq? target 'val) (not (eq? linkage 'return)))        ; linkage can ONLY be 'return or <label> - 'next was overridden by 'after-call in (compile-procedure-call)
         (make-instruction-sequence '(proc) all-regs                ; case 1 of 4: target=val, linkage=<label> - p. 586
           `((assign continue (label ,linkage))                         ; continue = (label <linkage>)
             (assign val (op compiled-procedure-entry)                  ; val = (entry-point proc) [trash register]
                         (reg proc))
             (goto (reg val)))))                                        ; goto (entry-point proc)
        ((and (not (eq? target 'val))                               ; case 2 of 4: target!=val, linkage=<label> - p. 585
              (not (eq? linkage 'return)))                              ; the least efficient case - need to return here and transfer result from val to target
         (let ((proc-return (make-label 'proc-return)))
           (make-instruction-sequence '(proc) all-regs                      ; p. 587: a procedure body could trash ANY registers!
            `((assign continue (label ,proc-return))                    ; continue = proc-return
              (assign val (op compiled-procedure-entry)                 ; val = (entry-point proc) [trash register]
                          (reg proc))
              (goto (reg val))                                          ; goto (entry-point proc)
              ,proc-return                                              ; proc-return
              (assign ,target (reg val))                                ; target = val [result of proc]
              (goto (label ,linkage))))))                               ; goto (label <linkage>)
        ((and (eq? target 'val) (eq? linkage 'return))              ; case 3 of 4: target=val, linkage=return - p. 586
         (make-instruction-sequence '(proc continue) all-regs           ; NEEDS continue implicitly, for the procedure's return point
          '((assign val (op compiled-procedure-entry)                   ; then continue is already ready! not coming back here ever again
                        (reg proc))                                     ; val = (entry-point proc) [trash register]
            (goto (reg val)))))                                         ; goto (entry-point proc)
        ((and (not (eq? target 'val)) (eq? linkage 'return))        ; case 4 of 4: target!=val, linkage=return - p. 585 Footnote 39; see also 
         (error "return linkage, target not val -- COMPILE"         ; this case is IMPOSSIBLE by the convention in (compile-lambda-body)
                target))))                                          ; p. 586: since case 3 is the only viable return linkage for procedure applications,
                                                                        ; the compiler is TAIL-RECURSIVE!! (why is this implemented here instead of compile-sequence, like eceval?)
;; footnote                                                             ; alternatively, case 4 would destroy tail recursion (because you MUST come back here to transfer val, which means you MUST save continue)
(define all-regs '(env proc val argl continue))                     ; Footnote 41, p. 587


;;;SECTION 5.5.4                                            ; <==== 5.5.4: Combining Instruction Sequences [and misc. syntax procedures]
                                                                ; instruction sequence = (needed modified instructions)
(define (registers-needed s)                                        ; ONLY invoked below (but used implicitly above)
  (if (symbol? s) '() (car s)))                                         ; (registers-needed label) = '() - "degenerate instruction"

(define (registers-modified s)                                      ; ONLY invoked below
  (if (symbol? s) '() (cadr s)))                                        ; (registers-needed label) = '()

(define (statements s)                                              ; ONLY invoked below
  (if (symbol? s) (list s) (caddr s)))                                  ; (instructions label) = (label)

(define (needs-register? seq reg)                                   ; ONLY invoked in (preserving)
  (memq reg (registers-needed seq)))                                    ; these determine whether a sequence needs/modifies a given register

(define (modifies-register? seq reg)                                ; ONLY invoked in (preserving)
  (memq reg (registers-modified seq)))


(define (append-instruction-sequences . seqs)                   ; the basic combiner, previewed in 5.5.1 on p. 572: append all, with register analysis to simplify (preserving)
  (define (append-2-sequences seq1 seq2)
    (make-instruction-sequence                                      ; overview of register metadata: p. 573
     (list-union (registers-needed seq1)                            ; all inputs = inputs of seq1, and...
                 (list-difference (registers-needed seq2)               ; inputs of seq2...
                                  (registers-modified seq1)))           ; that are not outputs of seq1
     (list-union (registers-modified seq1)                          ; all outputs = outputs of seq 1 + outputs of seq2.
                 (registers-modified seq2))
     (append (statements seq1) (statements seq2))))
  (define (append-seq-list seqs)
    (if (null? seqs)
        (empty-instruction-sequence)
        (append-2-sequences (car seqs)                              ; append sequences two at a time
                            (append-seq-list (cdr seqs)))))
  (append-seq-list seqs))

(define (list-union s1 s2)                                      ; cf. unordered sets from 2.3.3
  (cond ((null? s1) s2)
        ((memq (car s1) s2) (list-union (cdr s1) s2))
        (else (cons (car s1) (list-union (cdr s1) s2)))))

(define (list-difference s1 s2)
  (cond ((null? s1) '())
        ((memq (car s1) s2) (list-difference (cdr s1) s2))          ; scans for each member of s1 in s2, instead of removing s2 from s1
        (else (cons (car s1)
                    (list-difference (cdr s1) s2)))))

(define (preserving regs seq1 seq2)                             ; the push/pop combiner, previewed in 5.5.1 on p. 572: returns ((wrap seq1) seq2), where 
  (if (null? regs)                                                  ; (wrap seq1) INTELLIGENTLY wraps seq1 with push/pop pairs for regs 
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
        (if (and (needs-register? seq2 first-reg)                   ; if seq2 READS reg...
                 (modifies-register? seq1 first-reg))               ; but seq1 WRITES (trashes) it...
            (preserving (cdr regs)                                  ; THEN
             (make-instruction-sequence                                 
              (list-union (list first-reg)                              ; (wrap seq1) now needs to read reg (to push it)
                          (registers-needed seq1))
              (list-difference (registers-modified seq1)                ; (wrap seq1) by CONSTRUCTION no longer trashes reg
                               (list first-reg))                        
              (append `((save ,first-reg))                              ; (wrap seq1) = (push reg) (seq1) (pop reg)
                      (statements seq1)                             ; ALL push/pops generated here! code generators don't worry about it.    
                      `((restore ,first-reg))))                     ; Footnote 42 p. 590: n-argument append is standard in Scheme.
             seq2)
            (preserving (cdr regs) seq1 seq2)))))                   ; walk down the list of registers to be preserved

(define (tack-on-instruction-sequence seq body-seq)             ; ONLY invoked by (compile-lambda)
  (make-instruction-sequence                                        ; appends body-seq to another sequence seq
   (registers-needed seq)                                           ; body-seq is NOT executed after seq
   (registers-modified seq)                                         ; so ONLY seq's register use matters.
   (append (statements seq) (statements body-seq))))

(define (parallel-instruction-sequences seq1 seq2)              ; ONLY invoked by (compile-if) and (compile-procedure-call)
  (make-instruction-sequence                                        ; append 2 alternative branches that follow a test.
   (list-union (registers-needed seq1)
               (registers-needed seq2))                             ; <--- the only difference with the 2-seq case of (append-instruction-sequences)
   (list-union (registers-modified seq1)                                ; this is because the outputs of seq1 do NOT feed into inputs of seq2!
               (registers-modified seq2))                           ; i feel like this could be optimized further...meh
   (append (statements seq1) (statements seq2))))

'(COMPILER LOADED)
