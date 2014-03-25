(load "2.33-37-accumulate.scm")

; from section 2.2.2
(define (count-leaves x)
  (cond ((null? x) 0)           ; order matters, because by DEFINITION we don't count nil as a leaf - even though you could think of it as a leaf consisting of the empty list
        ((not (pair? x)) 1)         ; this is analogous to how the nil element in a list isn't included in (length)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define (count-leaves-accum t)
  (accumulate 
    ;+           ; <??> operation
    ;0           ; <??> initial value
    
    ; maybe map the tree onto a list? or onto a tree of lengths?
    (map        ; target sequence for accumulate
        ;(lambda (t) (count-leaves-accum t)) ; <??> map operation. cop out, and does not work.
        ;t                                   ; <??> target sequence for map
    )
  )
)



(define (test-2.35)

    (define (test y)
        (newline) (display y)
        (display "\noriginal: ") (display (count-leaves y))
        (display "\naccum: ") (display (count-leaves-accum y))
    )
    
    (let ((x (cons (list 1 2) (list 3 4))))
        (test x)
        (test (list x x))
    )
)
            

(test-2.35)