; from ch3.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;SECTION 3.5.2

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))


;;;Defining streams implicitly;;;Defining streams implicitly

(define ones (cons-stream 1 ones))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers (cons-stream 1 (add-streams ones integers)))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))