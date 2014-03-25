(load "2.33-37-accumulate.scm")
(define nil ())

; fun bite-sized riddles
(define (map-2.33 p sequence)
  (accumulate 
    (lambda (x y) 
        (append (list (p x)) y) ;<??> <--------------- my answer
    ) 
    nil 
    sequence))
    
    
(define (append-2.33 seq1 seq2)
  (accumulate 
    cons                        ; operation
    seq2                        ; <??> initial value
    seq1                        ; <??> sequence to iterate through. NOT (reverse seq1), because our (accumulate) iterates from the RIGHT
  )
)


(define (length-2.33 sequence)
  (accumulate 
    ;(lambda (x y) (+ x 1))     ; why doesn't this work!?!? oh, it's (op (car sequence) (accumulate...))
    (lambda (x y) (+ y 1))      ; <??> <----------- my answer. stupid brittle accumulate api
    0 
    sequence))
    
    

(define (test-2.33)

    (define (test L)
        (newline)
        (display (map square L)) (display " map square built-in\n")
        (display (map-2.33 square L)) (display " map-2.33 square\n")
        (display (append L (reverse L))) (display " append built-in\n")
        (display (append-2.33 L (reverse L))) (display " append-2.33\n")
        (display (length L)) (display " length built-in\n")
        (display (length-2.33 L)) (display " length-2.33\n")
    )
    
    (test (list 1 2 3 4 5))
)

(test-2.33)


    
        