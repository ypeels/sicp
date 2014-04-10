(load "3.55-partial-sums.scm")

; applying Euler's magic sequence accelerator from p. 336
; high-schoolish plug and chug!


; from ch3.scm
(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))    
        (s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))


(define (make-tableau transform s)
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))
              
              
              
              
; based on pi-summands
(define (log2-summands n)
    (cons-stream 
        (/ 1.0 n)
        (stream-map 
            -                               ; to alternate signs
            (log2-summands (+ n 1))
        )
    )
)

(define log2-stream-raw
    (partial-sums (log2-summands 1)))
    
(define log2-stream-euler
    (euler-transform log2-stream-raw))

(define log2-stream-super-euler
    (accelerated-sequence euler-transform log2-stream-raw))
    
    
(define (test-3.65)
    (let ((num-terms 30))
        
        (define (iter i)
            (if (< i num-terms)
                (begin
                    (newline) 
                    (display i) (display "\t")
                    (display (stream-ref log2-stream-raw i)) (display "\t")
                    (display (stream-ref log2-stream-euler i)) (display "\t")
                    (display (stream-ref log2-stream-super-euler i)) 
                    (iter (+ i 1))                    
                )
            )
        )
        (iter 0)
    )
)

;(test-3.65)

; exact answer is   .69314718055994530941723212145818
; raw is oscillating between .68 and .71 by 30 iterations
; euler-trans is    .693143186... by 30 iterations
; super-euler is    .6931471805599454 by 10 iterations, but returns #[NaN] thereafter...

                    
                    
    