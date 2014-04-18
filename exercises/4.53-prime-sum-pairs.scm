(load "4.51-53-permanent-set-and-if-fail.scm")

(define (test-4.53)

    (load "4.35-37-require.scm")
    (install-require) ; required by (an-element-of)

    (install-element-of) ; required by (prime-sum-pair)

    (ambeval-batch
    
        ; from ch4.scm
        '(define (prime-sum-pair list1 list2)
          (let ((a (an-element-of list1))
                (b (an-element-of list2)))
            (require (prime? (+ a b)))
            (list a b)))
            
        ; from ch1.scm
        '(define (smallest-divisor n)
          (find-divisor n 2))

        '(define (find-divisor n test-divisor)
          (cond ((> (square test-divisor) n) n)
                ((divides? test-divisor n) test-divisor)
                (else (find-divisor n (+ test-divisor 1)))))

        '(define (divides? a b)
          (= (remainder b a) 0))

        '(define (prime? n)
          (= n (smallest-divisor n)))
        
    
        '(define (t)
        
            ; from problem statement
            (let ((pairs '()))
              (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
                         (permanent-set! pairs (cons p pairs))
                         (amb))
                       pairs))
        )
        ; ((8 35) (3 110) (3 20))
        ; as you can see, the permanent-set! lets you set a history maintained through the multiverse
        ; also, the unconditional (amb) inside the first expression means ALL possibilities are explored
            ; the possibilities are stored in pairs, and then returned.
            ; not exactly self-documenting code...
        
    
    )
    
    (driver-loop)
)
(define analyze analyze-4.52) (test-4.53)