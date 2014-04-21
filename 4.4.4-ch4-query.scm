;;;;QUERY SYSTEM FROM SECTION 4.4.4 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch4.scm
;;;;Includes:
;;;;  -- supporting code from 4.1, chapter 3, and instructor's manual
;;;;  -- data base from Section 4.4.1 -- see microshaft-data-base below

;;;;This file can be loaded into Scheme as a whole.
;;;;In order to run the query system, the Scheme must support streams.

;;;;NB. PUT's are commented out and no top-level table is set up.
;;;;Instead use initialize-data-base (from manual), supplied in this file.


;;;SECTION 4.4.4.1                                                      ; finally caved and used quadruple section numbers
;;;The Driver Loop and Instantiation

(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read))))                              ; 4.4.4.7: pre-process query syntax for efficient processing; 4.4.4.3 p. 475: (read) NATIVELY supports dotted-tail notation.
    (cond ((assertion-to-be-added? q)                                   ; 4.4.4.7: (assertion-to-be-added?) and (add-assertion-body)
           (add-rule-or-assertion! (add-assertion-body q))              ; 4.4.4.5: (add-rule-or-assertion!)
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           ;; [extra newline at end] (announce-output output-prompt)
           (display-stream
            (stream-map
             (lambda (frame)
               (instantiate q                                           ; concrete instantiations for display
                            frame
                            (lambda (v f)
                              (contract-question-mark v))))             ; 4.4.4.7 - transform back to input representation - i.e., undo (query-syntax-process)
             (qeval q (singleton-stream '()))))                         ; with initial frame stream of a single empty frame
           (query-driver-loop)))))                                          ; result: a stream of frames generated by satisfying the query with variable values found in the data base

(define (instantiate expr frame unbound-var-handler)
  (define (copy expr)
    (cond ((var? expr)
           (let ((binding (binding-in-frame expr frame)))               ; 4.4.4.8: replace any variables by their values in the frame. also, (binding-value)
             (if binding
                 (copy (binding-value binding))                         ; values themselves need to be instantiated (they might be vars, or lists)
                 (unbound-var-handler expr frame))))                    ; unbound variable is passed to EXTERNAL handler from arguments
          ((pair? expr)
           (cons (copy (car expr)) (copy (cdr expr))))                  ; lists are instantiated item by item (converts from query to Lisp object)
          (else expr)))
  (copy expr))


;;;SECTION 4.4.4.2
;;;The Evaluator                                                        ; <==== "qeval ... is the basic evaluator of the query system."

(define (qeval query frame-stream)                                          ; args: a query and a stream of frames; return-val: a stream of extended frames (although this latter doesn't seem to be obvious from this function itself)
  (let ((qproc (get (type query) 'qeval)))                                  ; identifies special forms by data-directed dispatch (cf. 2.5)
    (if qproc
        (qproc (contents query) frame-stream)                               ; 4.4.4.7: (type) and (contents) implement the abstract syntax of the special forms.
        (simple-query query frame-stream))))                                ; Any query that is not identified as a special form is assumed to be a simple query

;;;Simple queries

(define (simple-query query-pattern frame-stream)                       ; returns the stream formed by extending each frame by all data-base matches of the query.
  (stream-flatmap                                                           ; 4.4.4.6 - one large stream of all ways to extend frames to match pattern
   (lambda (frame)                                                          ; strategy from p. 461
     (stream-append-delayed                                                 ; from 4.4.4.6; see also Exercise 4.71
      (find-assertions query-pattern frame)                                 ; 4.4.4.3 - match the pattern against all assertions in the data base, producing a stream of extended frames
      (delay (apply-rules query-pattern frame))))                           ; 4.4.4.4 - apply all possible rules, producing another stream of extended frames
   frame-stream))

;;;Compound queries

(define (conjoin conjuncts frame-stream)                                ; (AND) queries - Figure 4.5 p. 456
  (if (empty-conjunction? conjuncts)                                        ; 4.4.4.7: predicates and selectors
      frame-stream
      (conjoin (rest-conjuncts conjuncts)                                   ; process results in series
               (qeval (first-conjunct conjuncts)                            ; all possible frame extensions that satisfy the first query in the conjunction
                      frame-stream))))

;;(put 'and 'qeval conjoin)                                                 ; from (initialize-data-base) - so (get 'and 'qeval) will dispatch here.


(define (disjoin disjuncts frame-stream)                                ; (OR) queries - Figure 4.6 p. 457
  (if (empty-disjunction? disjuncts)                                        ; 4.4.4.7: predicates and selectors
      the-empty-stream
      (interleave-delayed                                                   ; 4.4.4.6 and exercises 4.71, 4.72
       (qeval (first-disjunct disjuncts) frame-stream)
       (delay (disjoin (rest-disjuncts disjuncts)                           ; interleave the results in parallel instead of processing in series
                       frame-stream)))))

;;(put 'or 'qeval disjoin)                                                  ; from (initialize-data-base) - so (get 'or 'qeval) will dispatch here.

;;;Filters

(define (negate operands frame-stream)                                  ; (NOT) filters - p. 457
  (stream-flatmap
   (lambda (frame)
     (if (stream-null? (qeval (negated-query operands)                      ; attempt to extend each frame in input stream to satisfy the query being negated
                              (singleton-stream frame)))                    ; 4.4.4.7: selectors
         (singleton-stream frame)                                           ; include a given frame in the output stream only if it cannot be extended 
         the-empty-stream))
   frame-stream))

;;(put 'not 'qeval negate)                                                  ; from (initialize-data-base) - so (get 'not 'qeval) will dispatch here.

(define (lisp-value call frame-stream)                                  ; Lisp filters - p. 458
  (stream-flatmap
   (lambda (frame)
     (if (execute
          (instantiate
           call
           frame
           (lambda (v f)                                                    ; (unbound-var-handler var frame). remember?
             (error "Unknown pat var -- LISP-VALUE" v))))                   ; error: unbound pattern variables
         (singleton-stream frame)
         the-empty-stream))                                                 ; frames for which the predicate returns false are filtered out
   frame-stream))

;;(put 'lisp-value 'qeval lisp-value)                                       ; from (initialize-data-base) - so (get 'lisp-value 'qeval) will dispatch here.

(define (execute expr)                                                  ; applies Lisp predicate to query arguments using UNDERLYING apply/eval!
  (apply (eval (predicate expr) user-initial-environment)                   ; (predicate) from 4.4.4.7; user-initial-environment is built-in.
         (args expr)))                                                      ; (args) from 4.4.4.7: not (eval (args expr)), since args of expr come in pre-evaluated
                                                                                ; ok, (eval) is what magically pulls the lisp function into the query system.
(define (always-true ignore frame-stream) frame-stream)                 ; special form used by (rule-body) in 4.4.4.7 for bodyless rules (conclusions always satisfied)

;;(put 'always-true 'qeval always-true)

;;;SECTION 4.4.4.3
;;;Finding Assertions by Pattern Matching

(define (find-assertions pattern frame)                                 ; returns stream of frames extended by the database match
  (stream-flatmap (lambda (datum)
                    (check-an-assertion datum pattern frame))
                  (fetch-assertions pattern frame)))                        ; 4.4.4.5: stream of assertions to be checked (cheap pre-check - p. 455 Footnote 67?)

(define (check-an-assertion assertion query-pat query-frame)            ; helper function ONLY used by (find-assertions)
  (let ((match-result
         (pattern-match query-pat assertion query-frame)))                  ; match? (punt)
    (if (eq? match-result 'failed)
        the-empty-stream                                                    ; match failed
        (singleton-stream match-result))))                                  ; match succeeded! return one-element stream w/ the extended frame

(define (pattern-match pat dat frame)                                   ; helper function ONLY used in 4.4.4.3 - returns extended frame OR 'failed
  (cond ((eq? frame 'failed) 'failed)                                       ; 'failed will cascade all the way home.
        ((equal? pat dat) frame)                                            ; match succeeds (not a variable!) - do nothing.
        ((var? pat) (extend-if-consistent pat dat frame))                   ; extend frame if consistent (punt)
        ((and (pair? pat) (pair? dat))                                      ; check pattern vs data, element by element, accumulating bindings for the pattern variables.
         (pattern-match (cdr pat)                                           ; recurse on 2nd+ elements
                        (cdr dat)
                        (pattern-match (car pat)                            ; frame extended by 1st element
                                       (car dat)
                                       frame)))
        (else 'failed)))

(define (extend-if-consistent var dat frame)                            ; helper function ONLY used by (pattern-match)
  (let ((binding (binding-in-frame var frame)))                             ; from 4.4.4.8
    (if binding
        (pattern-match (binding-value binding) dat frame)                   ; pp 474-5: reality check, OR recursively check variables bound as values during unification
        (extend var dat frame))))                                           ; from 4.4.4.8: bind previously unbound variable.

;;;SECTION 4.4.4.4                                                      ; ok, now to move beyond simple queries...
;;;Rules and Unification

(define (apply-rules pattern frame)
  (stream-flatmap (lambda (rule)
                    (apply-a-rule rule pattern frame))
                  (fetch-rules pattern frame)))

(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
           (unify-match query-pattern
                        (conclusion clean-rule)
                        query-frame)))
      (if (eq? unify-result 'failed)
          the-empty-stream
          (qeval (rule-body clean-rule)
                 (singleton-stream unify-result))))))

(define (rename-variables-in rule)
  (let ((rule-application-id (new-rule-application-id)))
    (define (tree-walk expr)
      (cond ((var? expr)
             (make-new-variable expr rule-application-id))
            ((pair? expr)
             (cons (tree-walk (car expr))
                   (tree-walk (cdr expr))))
            (else expr)))
    (tree-walk rule)))

(define (unify-match p1 p2 frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? p1 p2) frame)
        ((var? p1) (extend-if-possible p1 p2 frame))
        ((var? p2) (extend-if-possible p2 p1 frame)) ; {\em ; ***}
        ((and (pair? p1) (pair? p2))
         (unify-match (cdr p1)
                      (cdr p2)
                      (unify-match (car p1)
                                   (car p2)
                                   frame)))
        (else 'failed)))

(define (extend-if-possible var val frame)
  (let ((binding (binding-in-frame var frame)))
    (cond (binding
           (unify-match
            (binding-value binding) val frame))
          ((var? val)                     ; {\em ; ***}
           (let ((binding (binding-in-frame val frame)))
             (if binding
                 (unify-match
                  var (binding-value binding) frame)
                 (extend var val frame))))
          ((depends-on? val var frame)    ; {\em ; ***}
           'failed)
          (else (extend var val frame)))))

(define (depends-on? expr var frame)
  (define (tree-walk e)
    (cond ((var? e)
           (if (equal? var e)
               true
               (let ((b (binding-in-frame e frame)))
                 (if b
                     (tree-walk (binding-value b))
                     false))))
          ((pair? e)
           (or (tree-walk (car e))
               (tree-walk (cdr e))))
          (else false)))
  (tree-walk expr))

;;;SECTION 4.4.4.5
;;;Maintaining the Data Base

(define THE-ASSERTIONS the-empty-stream)

(define (fetch-assertions pattern frame)                                    ; helper function ONLY used in (find-assertions)
  (if (use-index? pattern)
      (get-indexed-assertions pattern)
      (get-all-assertions)))

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
  (get-stream (index-key-of pattern) 'assertion-stream))

(define (get-stream key1 key2)
  (let ((s (get key1 key2)))
    (if s s the-empty-stream)))

(define THE-RULES the-empty-stream)

(define (fetch-rules pattern frame)
  (if (use-index? pattern)
      (get-indexed-rules pattern)
      (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
  (stream-append
   (get-stream (index-key-of pattern) 'rule-stream)
   (get-stream '? 'rule-stream)))

(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
      (add-rule! assertion)
      (add-assertion! assertion)))

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
          (cons-stream assertion old-assertions))
    'ok))

(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES (cons-stream rule old-rules))
    'ok))

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
      (let ((key (index-key-of assertion)))
        (let ((current-assertion-stream
               (get-stream key 'assertion-stream)))
          (put key
               'assertion-stream
               (cons-stream assertion
                            current-assertion-stream))))))

(define (store-rule-in-index rule)
  (let ((pattern (conclusion rule)))
    (if (indexable? pattern)
        (let ((key (index-key-of pattern)))
          (let ((current-rule-stream
                 (get-stream key 'rule-stream)))
            (put key
                 'rule-stream
                 (cons-stream rule
                              current-rule-stream)))))))

(define (indexable? pat)
  (or (constant-symbol? (car pat))
      (var? (car pat))))

(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key) '? key)))

(define (use-index? pat)
  (constant-symbol? (car pat)))

;;;SECTION 4.4.4.6
;;;Stream operations

(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (stream-append-delayed (stream-cdr s1) delayed-s2))))

(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (interleave-delayed (force delayed-s2)
                           (delay (stream-cdr s1))))))

(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave-delayed
       (stream-car stream)
       (delay (flatten-stream (stream-cdr stream))))))


(define (singleton-stream x)
  (cons-stream x the-empty-stream))


;;;SECTION 4.4.4.7
;;;Query syntax procedures

(define (type expr)
  (if (pair? expr)
      (car expr)
      (error "Unknown expression TYPE" expr)))

(define (contents expr)
  (if (pair? expr)
      (cdr expr)
      (error "Unknown expression CONTENTS" expr)))

(define (assertion-to-be-added? expr)
  (eq? (type expr) 'assert!))

(define (add-assertion-body expr)
  (car (contents expr)))

(define (empty-conjunction? exps) (null? exps))
(define (first-conjunct exps) (car exps))
(define (rest-conjuncts exps) (cdr exps))

(define (empty-disjunction? exps) (null? exps))
(define (first-disjunct exps) (car exps))
(define (rest-disjuncts exps) (cdr exps))

(define (negated-query exps) (car exps))

(define (predicate exps) (car exps))
(define (args exps) (cdr exps))


(define (rule? statement)
  (tagged-list? statement 'rule))

(define (conclusion rule) (cadr rule))

(define (rule-body rule)
  (if (null? (cddr rule))
      '(always-true)
      (caddr rule)))

(define (query-syntax-process expr)
  (map-over-symbols expand-question-mark expr))

(define (map-over-symbols proc expr)
  (cond ((pair? expr)
         (cons (map-over-symbols proc (car expr))
               (map-over-symbols proc (cdr expr))))
        ((symbol? expr) (proc expr))
        (else expr)))

(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
        (list '?
              (string->symbol
               (substring chars 1 (string-length chars))))
        symbol)))

(define (var? expr)
  (tagged-list? expr '?))

(define (constant-symbol? expr) (symbol? expr))

(define rule-counter 0)

(define (new-rule-application-id)
  (set! rule-counter (+ 1 rule-counter))
  rule-counter)

(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var))))

(define (contract-question-mark variable)
  (string->symbol
   (string-append "?" 
     (if (number? (cadr variable))
         (string-append (symbol->string (caddr variable))
                        "-"
                        (number->string (cadr variable)))
         (symbol->string (cadr variable))))))


;;;SECTION 4.4.4.8
;;;Frames and bindings
(define (make-binding variable value)
  (cons variable value))

(define (binding-variable binding)
  (car binding))

(define (binding-value binding)
  (cdr binding))


(define (binding-in-frame variable frame)
  (assoc variable frame))

(define (extend variable value frame)
  (cons (make-binding variable value) frame))


;;;;From Section 4.1

(define (tagged-list? expr tag)
  (if (pair? expr)
      (eq? (car expr) tag)
      false))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))


;;;;Stream support from Chapter 3

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x)
  (newline)
  (display x))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-append s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (stream-append (stream-cdr s1) s2))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

;;;;Table support from Chapter 3, Section 3.3.3 (local tables)

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

;;;; From instructor's manual

(define get '())

(define put '())

(define (initialize-data-base rules-and-assertions)
  (define (deal-out r-and-a rules assertions)
    (cond ((null? r-and-a)
           (set! THE-ASSERTIONS (list->stream assertions))
           (set! THE-RULES (list->stream rules))
           'done)
          (else
           (let ((s (query-syntax-process (car r-and-a))))
             (cond ((rule? s)
                    (store-rule-in-index s)
                    (deal-out (cdr r-and-a)
                              (cons s rules)
                              assertions))
                   (else
                    (store-assertion-in-index s)
                    (deal-out (cdr r-and-a)
                              rules
                              (cons s assertions))))))))
  (let ((operation-table (make-table)))
    (set! get (operation-table 'lookup-proc))
    (set! put (operation-table 'insert-proc!)))
  (put 'and 'qeval conjoin)
  (put 'or 'qeval disjoin)
  (put 'not 'qeval negate)
  (put 'lisp-value 'qeval lisp-value)
  (put 'always-true 'qeval always-true)
  (deal-out rules-and-assertions '() '()))

;; Do following to reinit the data base from microshaft-data-base
;;  in Scheme (not in the query driver loop)
;; (initialize-data-base microshaft-data-base)

(define microshaft-data-base
  '(
;; from section 4.4.1
(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
(job (Bitdiddle Ben) (computer wizard))
(salary (Bitdiddle Ben) 60000)

(address (Hacker Alyssa P) (Cambridge (Mass Ave) 78))
(job (Hacker Alyssa P) (computer programmer))
(salary (Hacker Alyssa P) 40000)
(supervisor (Hacker Alyssa P) (Bitdiddle Ben))

(address (Fect Cy D) (Cambridge (Ames Street) 3))
(job (Fect Cy D) (computer programmer))
(salary (Fect Cy D) 35000)
(supervisor (Fect Cy D) (Bitdiddle Ben))

(address (Tweakit Lem E) (Boston (Bay State Road) 22))
(job (Tweakit Lem E) (computer technician))
(salary (Tweakit Lem E) 25000)
(supervisor (Tweakit Lem E) (Bitdiddle Ben))

(address (Reasoner Louis) (Slumerville (Pine Tree Road) 80))
(job (Reasoner Louis) (computer programmer trainee))
(salary (Reasoner Louis) 30000)
(supervisor (Reasoner Louis) (Hacker Alyssa P))

(supervisor (Bitdiddle Ben) (Warbucks Oliver))

(address (Warbucks Oliver) (Swellesley (Top Heap Road)))
(job (Warbucks Oliver) (administration big wheel))
(salary (Warbucks Oliver) 150000)

(address (Scrooge Eben) (Weston (Shady Lane) 10))
(job (Scrooge Eben) (accounting chief accountant))
(salary (Scrooge Eben) 75000)
(supervisor (Scrooge Eben) (Warbucks Oliver))

(address (Cratchet Robert) (Allston (N Harvard Street) 16))
(job (Cratchet Robert) (accounting scrivener))
(salary (Cratchet Robert) 18000)
(supervisor (Cratchet Robert) (Scrooge Eben))

(address (Aull DeWitt) (Slumerville (Onion Square) 5))
(job (Aull DeWitt) (administration secretary))
(salary (Aull DeWitt) 25000)
(supervisor (Aull DeWitt) (Warbucks Oliver))

(can-do-job (computer wizard) (computer programmer))
(can-do-job (computer wizard) (computer technician))

(can-do-job (computer programmer)
            (computer programmer trainee))

(can-do-job (administration secretary)
            (administration big wheel))

(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
           (address ?person-2 (?town . ?rest-2))
           (not (same ?person-1 ?person-2))))

(rule (same ?x ?x))                                                 ; Footnote 66: "allow rules without bodies...to mean that the rule conclusion is satisfied by any values of the variables."

(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
           (supervisor ?x ?middle-manager)))

(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))
))






; new convenience function. TODO: "batch queries" like with (ambeval-batch) and (leval)
(define (run) 
    (initialize-data-base microshaft-data-base)
    (query-driver-loop)
)



; new convenience functions - for running batch scripts. based on (query-driver-loop)
(define (init-query)
    (initialize-data-base microshaft-data-base))    
(define (query input)

    (define (done) (display "\nOkie dokie, boss\n\n"))
    
  ;(prompt-for-input 
  (display "\n;;; Input from batch file\n")
  (display input)
  (newline)

  (let ((q (query-syntax-process input)))
    (cond ((assertion-to-be-added? q)
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (done)) ;(query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           ;; [extra newline at end] (announce-output output-prompt)
           (display-stream
            (stream-map
             (lambda (frame)
               (instantiate q
                            frame
                            (lambda (v f)
                              (contract-question-mark v))))
             (qeval q (singleton-stream '()))))
           (done))))) ;(query-driver-loop)))))

; and a convenience function for installing rules
; no; use (assert!) from sols.
;(define (install-rule rule)
;    (append! microshaft-data-base (list rule)))
