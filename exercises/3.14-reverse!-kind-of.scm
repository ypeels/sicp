; Exercise 3.14.  The following procedure is quite useful, although obscure:
(define (mystery x)
  (define (loop x y)
    (if (null? x)
        y
        (let ((temp (cdr x)))       ; temp = (cdr x) [saved value]
          (set-cdr! x y)            ; (cdr x) = y
          (loop temp x))))          ; (loop [old (cdr x)] ((car x) . y))
  (loop x '()))                     ; initial y is nil.
  
  
; first iteration: x = '(1 2 3 4 ... n), say
;   (loop x '())
;       (set-cdr! x '())
;       (loop (2 3 4 ... n) (1 . ()))

; second iteration: x = (2 3 4 ... n)
;   (loop x (1 . ()))
;       (set-cdr! x (1 . ()))
;       (loop (3 4 ... n) (2 1))

; termination? x = (n), y = (n-1 n-2 ... 2 1)
;   (loop x y )
;       (set-cdr! x y)
;       (loop '() (n n-1 ... 2 1))
; aha, it takes one "extra" iteration to terminate.



; In general, mystery == reverse! (which is a built-in, btw).
    ; an "in-place reverse" that destroys the original list.
    ; actually, it's not QUITE like that
    
    ; In iteration 1, (set-cdr! x '()) is applied to the ORIGINAL LIST
    ; thus, (mystery x) returns (reverse x), 
        ; and has the side effect of setting x to (list (car x)).
        
; from problem statement
(define v (list 'a 'b 'c 'd))
(define w (mystery v))
(display "\nw: ") (display w)   ; (d b c a)
(display "\nv: ") (display v)   ; (a)