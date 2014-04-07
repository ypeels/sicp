; from ch3.scm
;;;SECTION 3.3.3

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))

;(define (assoc key records)
;  (cond ((null? records) false)
;        ((equal? key (caar records)) (car records))
;        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))

; from problem statement
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))
                 
(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
        (or previously-computed-result              ; idiom (almost Pythonic?): lazy evaluation of or.
            (let ((result (f x)))
              (insert! x result table)
              result))))))
                 
(define memo-fib                                    ; O(n) even though table lookup in GENERAL is O(n)
  (memoize (lambda (n)                              ; this is because memo-fib only needs to look up the last ~2 table entries
  (newline) (display n)
             (cond ((= n 0) 0)                          ; ??? is that comment right?? ^^^^ basically... (see intuition)
                   ((= n 1) 1)
                   (else (+ (memo-fib (- n 1))
                            (memo-fib (- n 2))))))))
                       

; new for the exercise                       
(define memo-fib-cheap (memoize fib))

    
(define (memo-fib-cheap2 n)
    (define (iter i)
        (display i)
        (memo-fib-cheap i)
        (memo-fib-cheap (+ i 1))
        (memo-fib-cheap (+ i 2))
        (if (< i n)
            (iter (+ i 1))
            (memo-fib-cheap i)
        )
    )
    (iter 1)
)

              

(define (test n)              
    (display "\n\nn = ") (display n)
    (display "\nmemo-fib: ") (display (memo-fib n))              
    
    ; this will be SLOW because it only memoizes the final result, not the intermediate ones
    ; so MAYBE repeated calls will be fast
    ; and if you have n-1 and n-2, then n will be fast? MAYBE?
        ; although you COULD hack a cheap version that made sure it called memo-fib-cheap for all smaller n
        ; same effect as memo-fib, but more overhead
    ;(display "\n(memoize fib) - slow: ") (display (memo-fib-cheap n))
    
    ; this didn't work either, even though i thought it would...
    ; even though it works at the interpreter level, typing in (memo-fib-cheap 28, 29, 30)
    ; oh, table lookup is getting slower?
    ;(display "\n(memoize fib) - hacked to be fast?: ") (display (memo-fib-cheap2 n))
    
    ; NO! memo-fib-cheap will work fine for repeated calls for the same n
    ; but for any different n, it will recompute from scratch, because fib calls fib, NOT memo-fib-cheap
    ; the real mystery is why typing (memo-fib-cheap 30) (memo-fib-cheap 31) (memo-fib-cheap 32) 
        ; at the interactive interpreter is not slow... maybe the interpreter is CACHING some results itself?
        ; actually, i think i was just wrong about that - the first call seems JUST as slow as fib.
        
    ; note that this is still slower than (fib-iter) from section 1.2.2
        ; storage/lookup overhead
        ; cramming a recursive structure down this iterative problem's throat
)

(test 10)
    

    
; intuition: what if initial call to memo-fib had a HUGE n? 
    ; ok, remember from 1.2.2  before the problem was REDUNDANCY - (fib 2) was getting recomputed 
    
    ; does an initial call to (memo-fib 100) NOT generate a huge tree of calls?
    ; does it all come down to "applicative order evaluation"? 
        ; yes, inserting a quick (display) in memo-fib shows that it recurses linearly ALL THE WAY down one branch
            ; in particular, the second argument determines the stride (evaluating right to left, as per Exercise 3.8)
    ; this way, memo-fib only gets called ONCE, all the way down the linear branch
        ; the other branches get pruned on the way back up, and they're just (supposedly cheap) table lookups anyway
    
    ; however, is this REALLY O(n)?? Isn't table lookup itself O(n), and then you have to do O(n) lookups??
        ; maybe the INITIAL call is O(n) but slow, and subsequents calls are O(n^2) but VERY fast since it's pre-computed
        ; also, note that the built-in assoc is MUCH faster
        ; but the table is still just simply linear, so i'm not totally sure 
        ; https://groups.csail.mit.edu/mac/ftpdir/scheme-7.4/doc-html/scheme_12.html
        ; "the average lookup time for an association list is linear in the number of associations."
        ; HOWEVER, once again, thanks to applicative order, the tree gets pruned with RECENT ADDITIONS
            ; popping the recursion stack, you'll only be looking up 2 or 3 results back via the fibonacci formula, which is a CONSTANT time
            ; this is a slightly more rigorous proof of my intuitive first-impression comment.


    
    
; and now the long/annoying part: drawing the frames (FRAMES!!!) to show where the state table is stored
; ugh, so much random implicit stuff going on with storage... unlike C, where you explicitly control scope


; Stage 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Global Frame G -----------------------------------------
; memoize: proc with param f, env G
; memo-fib: evaluate (memoize (lambda (n)...)) in frame F

; Frame F (child of G) : (memoize (lambda (n)...)) -------
; f: (lambda (n) ... )

; evaluate body of memoize
;  (let ((table (make-table)))
;    (lambda (x)
;      (let ((previously-computed-result (lookup x table)))
;        (or previously-computed-result
;            (let ((result (f x)))
;              (insert! x result table)
;              result
;            )
;        )
;      )
;    )
;  )
; remember from Exercise 3.10 that (let ((table)) ) is syntactic sugar for a (lambda (table)...) APPLICATION
; Carry out that application in new Frame F', child of F
; For argument, evaluate (make-table) in some trivial frame T, child of G (where make-table lives)


; Frame F' (child of F)-----------------------------------
; table: (list '*table*). THIS IS WHERE THE STATE TABLE LIVES PERSISTENTLY.
;    (lambda (x)
;      (let ((previously-computed-result (lookup x table)))
;        (or previously-computed-result
;            (let ((result (f x)))
;              (insert! x result table)
;              result
;            )
;        )
;      )
;    )

; Final result in G --------------------------------------
; memo-fib: (lambda (x)...) from F'


; Stage 1a ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (memo-fib 3)
; apply in child frame of F', where (lambda (x)...) lives.

; Frame F'' (child of F') --------------------------------
; x: 3
;      (let ((previously-computed-result (lookup x table)))
;        (or previously-computed-result
;            (let ((result (f x)))
;              (insert! x result table)
;              result
;            )
;        )
;      )
;   table: not found in F''
;   table: found in F' as (list '*table*)
; syntactic sugar for (lambda (previously-computed-result)...) applied to (lookup x table)
; Evaluate lookup in new frame L3.1a, child of G (where lookup lives)
; pending: apply lambda

; Frame L3.1a (child of G) ----------------------------------
; from G: 
;(define (lookup key table)
;  (let ((record (assoc key (cdr table))))
;    (if record
;        (cdr record)
;        false)))
; key: 3
; table: (list '*table*) from F'
; desugared: (lambda (record)...) applied to (assoc key (cdr table))
; evaluate assoc in temp new frame (child of G)
    ; trivially returns false because (cdr table) is null right now
; apply (lambda (record)) in new temp child frame, trivially returns false because record is false
; therefore return (lookup 3 table) = false to Frame F''

; back to Frame F'' ----------------------------------------
; apply (lambda (previously-computed-result)...) to false in new child frame F'''

; Frame F''' (child of F'') --------------------------------
; previously-computed-result: false
;        (or previously-computed-result
;            (let ((result (f x)))
;              (insert! x result table)
;              result
;            )
;        )
; desugared: apply (lambda (result) (insert! x result table) result) to (f x)
    ; x: 3 from F''
    ; f: (lambda (n)...) from F
    ; table: state variable from F'
    ; insert!: procedure from G
    ; call stack: will return (f 3) to F'' and then to F' and then to G, where (memo-fib 3) was originally called

    
; Stage 1b ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; apply (lambda (n)... ) to 3, to get result for Stage 1a.
; apply in new child frame F3.1b, child of F, where (lambda (n)...) lives

; Frame F3.1b -----------------------------------------------------
; n: 3
;             (cond ((= n 0) 0)                          
;                   ((= n 1) 1)
;                   (else (+ (memo-fib (- n 1))
;                            (memo-fib (- n 2)))))
; okay, HERE'S where things start to get interesting...

; "Draw an environment diagram to analyze the computation of (memo-fib 3)."
; it doesn't say FULL environment diagram of ALL steps.
; as long as i've analyzed the computation, things should be fine.,

; Need to evaluate (memo-fib 2) and (memo-fib 1).
; Applicative order: first evaluate ONE of these completely, before doing the other.
; (memo-fib 1) will be evaluated in a new child frame of F', where its body lives.
    ; lookup will fail, so it will evaluate and tabulate (f 1) which will just return 1.
    ; so in the end, the F' table will be updated.
; (memo-fib 2) will be evaluated in a new child frame of F'
    ; lookup will fail, so it will compute (f 2)
        ; (memo-fib 1) will be found in the table
        ; (memo-fib 0) will be computed in a new child frame of F', and it will return and tabulate 0.

; they didn't say what ASPECT of this they wanted analyzed, so i'm stopping here. sick of this.


    
