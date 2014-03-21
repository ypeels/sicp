
; 1.37a: the obvious approach is recursive...
(define (cont-frac n d K)
    (define (iter i)    ; not QUITE sure how to do this without adding an additional counter...
        (if (> i K) 
            0
            (/ (n i) (+ (d i) (iter (+ i 1))))))
    (iter 1))
    
    
; 1.37b: how about starting from the kth term? 
; maybe THIS is the "obvious" approach... since their "k" formal argument was LOWERCASE...
; but it DOES take more code to express, since the first iteration is 
(define (cont-frac-iter n d k)
    (define (iter n d k result)
        (if (< k 1)
            result
            (iter
                n
                d
                (- k 1)
                (/ (n k) (+ (d k) result)))))
    (iter 
        n           ; the coefficient functions (input)
        d 
        (- k 1)     ; pre-compute the first iteration!
        (/ (n k) (d k))))
    
    
    
; testing code
(define (test-1.37)

    
    (define (golden-ratio k method) 
        (method
            (lambda (i) 1.)
            (lambda (i) 1.)
            k))
    
    (define (test-golden-ratio k method)
        (display "\nk = ")
        (display k)
        (display ": ")
        (display (golden-ratio k method)))
        
    (define (test-suite method name)
        (newline)
        (newline)
        (display name)
        
        (display "\nexact = ")
        (display (/ 2 (+ 1 (sqrt 5))))  ; .6180339887498948    
        (test-golden-ratio 8  method)               
        (test-golden-ratio 9  method)           ; .6181818181818182
        (test-golden-ratio 10 method)          ; .6179775280898876 - accurate to 4 decimal places.
        (test-golden-ratio 50 method)          ; .6180339887498948 - converged to display accuracy!!
        name
    )
    
    (test-suite cont-frac "recursive (cont-frac)")
    (test-suite cont-frac-iter "iterative (cont-frac-iter)")
)


        
        
; run test code
(test-1.37)