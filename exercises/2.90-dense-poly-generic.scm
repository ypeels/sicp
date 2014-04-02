(load "2.77-80-generic-arithmetic.scm")

; like polar/rectangular complex numbers, this version will be able to perform operations on mixed sparse/dense polynomials


; forked completely, if for no other reason, to avoid cluttering the codebase COMPLETELY for subsequent exercises
    ; what does that say about the "modularity" of large scheme programs??
    ; and if this language is so wonderful and modular, then why is it SUCH A HASSLE to get this simple task done??
    
    
(define (install-polynomial-generic)

  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  
  ;;[procedures same-variable? and variable? from section 2.3.2]
    (define (variable? x) (symbol? x))

    (define (same-variable? v1 v2)
      (and (variable? v1) (variable? v2) (eq? v1 v2)))
      

    ; like (install-complex-package) in 2.77-80, you just DON'T WORRY about the representation
        ; just invoke PUBLIC FUNCTIONS only
        
        
    
    
        
  ;;(define (add-poly p1 p2) ... )
    (define (add-poly p1 p2)
      (if (same-variable? (variable p1) (variable p2))
          (make-poly 
            (variable p1)
            (let ((L1 (term-list p1)) (L2 (term-list p2)))
                (let ((n (max (order L1) (order L2))))
                    (make-term-list-from-dense
                        (map                            ; i can and SHOULD keep add here - because otherwise, there would be duplicated logic in both repns!
                            add                                                            ; cf. (install-complex-package), which contains the generic (add-complex, in terms of primitives (real-part and (imag-part        
                            (padded-dense-coeffs L1 n)
                            (padded-dense-coeffs L2 n)
                        )
                    )
                )
            )
          )
          (error "Polys not in same var -- ADD-POLY" (list p1 p2))
      )
    )
    

        
    ; primitives required for addition
        ; (first-term L? NO
        ; (rest-terms L? NO - change algorithms
        ; (empty-termlist? NO
        ; (order L --- NEW! useful for both old and new algorithms
        ; (padded-dense-coeffs n
        
        
        
        ; addition is more natural using sparse representation
            ; just call (map add coeffs1 coeffs2) after lengthening coeffs as needed
        ; multiplication is more natural using DENSE representation (i think)
            ; although note that this will punt to addition...
        

                 

 ; ;;(define (mul-poly p1 p2) ... )
 ;   (define (mul-poly p1 p2)
 ;     (if (same-variable? (variable p1) (variable p2))
 ;         (make-poly (variable p1)
 ;                    (mul-terms (term-list p1)
 ;                               (term-list p2)))
 ;         (error "Polys not in same var -- MUL-POLY"
 ;                (list p1 p2))))
 ;                
                 
    ; for simplicity, skipping Exercises 2.87-88 (polynomial coeffs and subtraction) 
        ; the soln for this isn't even UP on the wiki
        
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial-generic p))
  (put 'add '(polynomial-generic polynomial-generic) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))
;  (put 'mul '(polynomial-generic polynomial-generic) 
;       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial-generic
       (lambda (var terms) (tag (make-poly var terms))))
  "\nInstalled generic polynomials for Exercise 2.90.")
  
  
  
(define (install-dense)

    ; constructors. HERE is where tag information gets appended; apply-generic automagically strips it and sends data here.
    (define (make-from-dense L) L)
    (put 'make-from-dense 'dense (lambda (L) (tag (make-from-dense L))))
    
    
    ; operations on private data
    (define (order L) (- (length L) 1))
    (put 'order '(dense) order)
    
    (define (padded-dense-coeffs L n)
        (cond 
            ((not (integer? n))
                (error "Need integer n -- PADDED-DENSE-COEFFS" n))
            ((<= n (order L))
                L)
            (else
                (padded-dense-coeffs (cons 0 L) n))
        )
    )
    (put 'padded-dense-coeffs '(dense scheme-number) padded-dense-coeffs)
    
    
    ; misc.
    (define (tag x) (attach-tag 'dense x))  ; stupid scheme - to define a local variable, you'd have to wrap the WHOLE BLOCK in a let 
    
    "\nInstalled dense term list representation for Exercise 2.90."
)

(define (make-term-list-from-dense L)
    ((get 'make-from-dense 'dense) L))

(define (make-poly-from-dense var L)
    ((get 'make 'polynomial-generic)
        var
        (make-term-list-from-dense L)
    )
)

; expose public functionality
(define (order term-list)
    (apply-generic 'order term-list))
(define (padded-dense-coeffs term-list n)
    (apply-generic 'padded-dense-coeffs term-list n))


(display (install-polynomial-generic))
(display (install-dense))

(define y (make-poly-from-dense 'x '(1 0 1)))
(newline) (display y)


