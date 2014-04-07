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
        (or previously-computed-result
            (let ((result (f x)))
              (insert! x result table)
              result))))))
                 
(define memo-fib                                    ; O(n) even though table lookup in GENERAL is O(n)
  (memoize (lambda (n)                              ; this is because memo-fib only needs to look up the last 2 table entries
             (cond ((= n 0) 0)                          ; ??? 
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
    (display "\n(memoize fib) - hacked to be fast?: ") (display (memo-fib-cheap2 n))
)

(test 10)
    
    
; and now the long/annoying part: drawing the frames (FRAMES!!!) to show where the state table is stored