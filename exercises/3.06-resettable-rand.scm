; from ch3support.scm
(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))

; based loosely on (rand) from ch3.scm
(define random-init 7)			;**not in book**
(define (rand sym)

    (define rand-generate
        (let ((x random-init))
          (lambda ()
            (set! x (rand-update x))
            x))
    )

        
    ; sigh, HOW does this syntax work?? refer back to exercises 3.3-3.4

        (cond 
            ((eq? sym 'generate)
                ;(set! x (rand-update x))
                (rand-generate)         ; nope, the x inside (rand-generate is getting reset on every call
                ;(rand-generate)
            )
            (else (error "asdf"))
        )
    


)

;(define rand
;    (let ((x random-init))
;      (lambda ()
;        (set! x (rand-update x))
;        x))
;)

(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
(newline)(display (rand 'generate))
            
            

