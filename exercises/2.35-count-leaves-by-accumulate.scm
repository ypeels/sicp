(load "2.33-37-accumulate.scm")
(load "2.28-fringe-print-leaves.scm") (define enumerate-tree fringe) ; for my "cop-out"...


(define (count-leaves-accum t)
  (accumulate 
    (lambda (L sum) (+ sum (length L)))     ; <??> accumulate operation
    0                                       ; <??> initial value
    
    (map                                    ; flatten the tree into a list, which accumulate can then consume
        (lambda (t) (enumerate-tree t))         ; <??> map operation. not a cop out, is it? i mean, they did it in (sum-odd-squares)...
        t                                       ; <??> target sequence for map
    )
  )
)



(define (test-2.35)

    (define (test y)
        (newline) (display y)
        (display "\noriginal: ") (display (count-leaves y))
        (display "\naccum: ") (display (count-leaves-accum y))
    )
    
    ; from section 2.2.2
    (define (count-leaves x)
      (cond ((null? x) 0)           ; order matters, because by DEFINITION we don't count nil as a leaf - even though you could think of it as a leaf consisting of the empty list
            ((not (pair? x)) 1)         ; this is analogous to how the nil element in a list isn't included in (length)
            (else (+ (count-leaves (car x))
                     (count-leaves (cdr x))))))

    
    (let ((x (cons (list 1 2) (list 3 4))))
        (test x)            ; 4 leaves
        (test (list x x))   ; 8 leaves
    )
)
            

(test-2.35)
