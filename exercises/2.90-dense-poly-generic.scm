(load "2.77-80-generic-arithmetic.scm")
(load "2.80-equals-zero.scm")

; like polar/rectangular complex numbers, this version will be able to perform operations on mixed sparse/dense polynomials


; forked completely, if for no other reason, to avoid cluttering the codebase COMPLETELY for subsequent exercises
    ; what does that say about the "modularity" of large scheme programs??
    ; and if this language is so wonderful and modular, then why is it SUCH A HASSLE to get this simple task done??
    
    
; TODO
    ; simplify result to sparse or dense, depending on which consumes less storage
        ; current results display sums ONLY as dense (all coeffs, including 0)
            ; this is exactly what the polar/rectangular package does from exercises 2.77-80! good enough for me too.
            ; honestly, the dense results are much easier for humans to read



(define the-empty-termlist '())
            
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
      

  ;;(define (add-poly p1 p2) ... )
    (define (add-poly p1 p2)
        ;(display "\nadd-poly: ") (display p1) (display p2)
      (if (same-variable? (variable p1) (variable p2))
          (make-poly 
            (variable p1)
            (let ((L1 (term-list p1)) (L2 (term-list p2)))
                (let ((n (max (order L1) (order L2))))
                    ;(display (padded-dense-coeffs L1 n))
                    ;(display (padded-dense-coeffs L2 n))
                    ;(display "giggity")
                    
                    
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
    

        
        ; multiplication is more natural using DENSE representation, esp so you can just add the orders
            ; although note that this will punt to addition for the final sum...
            ; also, this means recycling lots of the original code, since that WAS sparse
    
        ; this'd all be much cleaner if i just used COERCION instead of low-level rect/polar style, but no...
                 

  ;;(define (mul-poly p1 p2) ... )
    (define (mul-poly p1 p2)
        ;(display "\nmul-poly: ")(display p1) (display p2)
      (if (same-variable? (variable p1) (variable p2))
          ;(make-poly 
          ;  (variable p1)
            
          (let ((L1 (term-list p1)) (L2 (term-list p2)))
              
              (cond
                  ((or (=zero-poly? p1) (=zero-poly? p2))
                     ; (display "00 something... ")
                      the-empty-term-list)
                  ((> (num-terms L1) 1)
                      ;(display "\nparing list 1")
                      
                      (let ((result1 (mul-poly (first-term-poly p1) p2)) (result2 (mul-poly (rest-terms-poly p1) p2)))
                      
                       ;   (display "\n\tparing list 1 results") (display result1) (display result2)
                      
                          (add-poly 
                              result1;(mul-poly (first-term-poly p1) p2)
                              result2;(mul-poly (rest-terms-poly p1) p2)
                          )
                      )
                  )
                  ((> (num-terms L2) 1)
                      ;(display "\nparing list 2")
                      
                      (let ((result1 (mul-poly p1 (first-term-poly p2))) (result2 (mul-poly p1 (rest-terms-poly p2))))
                      
                        ;  (display "\n\tparing list 2 input") (display p1) (display (first-term-poly p2))
                         ; (display "\n\tparing list 2 results") (display result1) (display result2)
                      
                          (add-poly
                              result1;(mul-poly p1 (first-term-poly p2))
                              result2;(mul-poly p1 (rest-terms-poly p2))
                          )
                      )
                  )
                  ((and (= 1 (num-terms L1)) (= 1 (num-terms L2)))    ; my algorithm pares it down to multiplication of single terms
                      ;(display "\nend of the line")
                      
                      (let ((result0
                          (make-poly
                              (variable p1)                          ; ~1-hour bug: there's a make-poly wraping this whole thing outside. that's what you get when you try to FORCIBLY enforce type in a weakly typed language...
                              (make-term-list-from-sparse
                                  (list (list 
                                      (add (order L1) (order L2))
                                      (mul (leading-coeff L1) (leading-coeff L2))
                                  ))
                              )
                          )
                          ))
                          ;(display "\tmul-poly result: ")
                          ;(display result0)
                          result0)
                  )
                  (else
                      (error "impossible case!? MUL-POLY: " p1 p2))
              )
          )
          
          (error "Polys not in same var -- MUL-POLY" (list p1 p2))
      )
    )
    
    ; oh my how ugly you are
    (define (first-term-poly p)
        ;(display "\n\tfirst-term-poly input") (display p)
        
        (let ((result 
            (make-poly 
                (variable p)
                (make-term-list-from-sparse
                    (list (list
                        (order (term-list p))                           ; should really just implement (first-term
                        (leading-coeff (term-list p))
                    ))
                )
            )
            ))
            ;(display "\tresult = ") (display result) (display "\n")
            result
        )
    )
    
    (define (rest-terms-poly p)
        ;(display "\nrest-term-poly") (display p)
        (make-poly
            (variable p)
            (trailing-terms (term-list p))
        )
    )
        
    
    
    (define (=zero-poly? p)
        ;(display "\n=zero-poly?") (display p)    
        (cond
            ((eq? the-empty-termlist (term-list p))
                true)
            ((=zero? (leading-coeff (term-list p)))
                (display "giggity")
                (=zero? (rest-terms-poly p)))
            (else false)
        )
    )
    (put '=zero? '(polynomial-generic) =zero-poly?) 
               
                 
    ; for simplicity, skipping Exercises 2.87-88 (polynomial coeffs and subtraction) 
        ; the soln for this isn't even UP on the wiki
        
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial-generic p))
  (put 'add '(polynomial-generic polynomial-generic) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial-generic polynomial-generic) 
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial-generic
       (lambda (var terms) (tag (make-poly var terms))))
  "\nInstalled generic polynomials for Exercise 2.90.")
  
  
  
(define (install-dense)

    (define (tag x) (attach-tag 'dense x))  ; stupid scheme - to define a local variable, you'd have to wrap the WHOLE BLOCK in a let 

    ; constructors. HERE is where tag information gets appended; apply-generic automagically strips it and sends data here.
    (define (make-from-dense L) L)
    (put 'make-from-dense 'dense (lambda (L) (tag (make-from-dense L))))
    
    ;(define (make-from-sparse L)
    ;)
    ;(put 'make-from-sparse 'dense (lambda (L) (tag (make-from-sparse L))))
    
    
    ; new operations 
    (define (order L) 
       ; (display "\norder dense") (display L)
        ;(error "\norder dense" L)
        (cond 
            ((null? L)
                0)
            ((and (pair? L) (=zero? (car L)))
                ;(display "\ndense order pruning")
                (order (cdr L)))
            ((pair? L)
                (max 0 (- (length L) 1)))
            (else
                (error "impossible case? order-dense" L))
        )
    )
    (put 'order '(dense) order)
    
    (define (padded-dense-coeffs L n)
        ;(display "\npadded-dense-coeffs dense")
        (cond 
            ((not (integer? n))
                (error "Need integer n -- PADDED-DENSE-COEFFS" n))
            ((null? L)                                              
                L)
            ((<= n (- (length L) 1)) ; we want to know total # coeffs, NOT (order L)
                L)
            (else
                ;(newline) (display n) (display " and order ") (display (order L)) ;(display L) 
                (padded-dense-coeffs (cons 0 L) n))
        )
    )
    (put 'padded-dense-coeffs '(dense scheme-number) padded-dense-coeffs)
    
    (define (leading-coeff L)
        (cond 
            ((null? L) 0)
            ((pair? L)
                (if (=zero? (car L))
                    (leading-coeff (cdr L))
                    (car L)
                )
            )
            (else (error "bad argument - LEADING-COEFF dense" L))
        )
    )
    (put 'leading-coeff '(dense) leading-coeff)
        
    (define (trailing-terms L)
       ; (display "\ntrailing-terms dense") (display L)
        (if (pair? L)
            (cdr L)
            (error "bad input? TRAILING-TERMS dense" L)
        )
    )
    (put 'trailing-terms '(dense) (lambda (L) (tag (trailing-terms L))))
    
    (define (num-terms L)
       ; (display "\nnum-terms dense") (display L)
        (cond
            ((null? L)
                0)
            ((=zero? (car L))
                (num-terms (cdr L)))
            (else
                (+ 1 (num-terms (cdr L))))
        )
    )       
    (put 'num-terms '(dense) num-terms)

    
    
    "\nInstalled dense term list representation for Exercise 2.90."
)


(define (install-sparse)

    (define (tag x) (attach-tag 'sparse x))
    
    ; constructors
    (define (make-from-sparse L) L)
    (put 'make-from-sparse 'sparse (lambda (L) (tag (make-from-sparse L))))
    
    
    ; original sparse API
    ;(define (make-term order coeff) (list order coeff))
    (define (order-term term) (car term))
    (define (coeff-term term) (cadr term))
    (define (first-term term-list) (car term-list))
    (define (rest-terms term-list) (cdr term-list))
  

    
    
    ; new operations
    (define (order L) 
        ;(display "\norder sparse") (display L)
        (if (null? L)                              ; not sure why this corner case pops up, but whatever    
            0
            (order-term (first-term L))
        )
    )

    (put 'order '(sparse) order)
    
    (define (padded-dense-coeffs L n)
        ;(display "\npacked-dense-coeffs sparse: ")
        (cond
            ((< n 0)
                the-empty-termlist)
            ((or (null? L) (< (order L) n))                        ; append leading 0 coeff
                (cons 0 (padded-dense-coeffs L (- n 1))))
            ((> (order L) n)                        ; don't destroy coeffs of order BIGGER than n, naturally
                (cons 
                    (coeff-term (first-term L)) 
                    (padded-dense-coeffs (rest-terms L) n)
                )
            )
            ((= (order L) n)
                (cons 
                    (coeff-term (first-term L))
                    (padded-dense-coeffs (rest-terms L) (- n 1))
                )
            )            
            (else
                (error "wtf? impossible case - PADDED-DENSE-COEFFS for sparse" L n))
        )
            
    )
    (put 'padded-dense-coeffs '(sparse scheme-number) padded-dense-coeffs)
    
    (define (leading-coeff L)
        (cond 
            ((null? L) 0)
            ((pair? L)
                (coeff-term (first-term L))
            )
            (else (error "bad argument - LEADING-COEFF sparse" L))
        )
    )    
    (put 'leading-coeff '(sparse) leading-coeff)
    
    (define (trailing-terms L)
        (if (pair? L)
            (cdr L)
            (error "bad input? TRAILING-TERMS sparse" L)
        )
    )
    (put 'trailing-terms '(sparse) (lambda (L) (tag (trailing-terms L))))

    (define (num-terms L)
        (length L))
    (put 'num-terms '(sparse) num-terms)
    
    
    
    "\nInstalled sparse term list representation for Exercise 2.90."
)



; expose public functionality
(define (make-term-list-from-dense L)
    ((get 'make-from-dense 'dense) L))
(define (make-poly-from-dense var L)
    ((get 'make 'polynomial-generic)
        var
        (make-term-list-from-dense L)
    )
)

(define (make-term-list-from-sparse L)
    ((get 'make-from-sparse 'sparse) L))
(define (make-poly-from-sparse var L)
    ((get 'make 'polynomial-generic)
        var
        (make-term-list-from-sparse L)
    )
)

(define (order term-list)                               ; SPECIFIED as the order of the term list
    ;(display "\norder generic") (display term-list)
    (apply-generic 'order term-list))
(define (padded-dense-coeffs term-list n)               ; SPECIFIED as (coeff_n ... coeff_1 coeff_0)
    ;(display "\npacked-dense-coeffs generic") (display term-list) (display n)
    (apply-generic 'padded-dense-coeffs term-list n))

(define (leading-coeff term-list)
    (apply-generic 'leading-coeff term-list))
(define (trailing-terms term-list)
    (apply-generic 'trailing-terms term-list))
(define (num-terms term-list)
    (apply-generic 'num-terms term-list))
    
    
    

(display (install-polynomial-generic))
(display (install-dense))
(display (install-sparse))

(define (test-2.90)

    (define (test y1 y2)
        (newline)
        (newline) (display y1) (display y2)
        (display "\nadd: ") (display (add y1 y2))
        (display "\nmul: ") (display (mul y1 y2))
    )
    
    (let (  (yd (make-poly-from-dense 'x '(1 0 1)))
            (ys (make-poly-from-sparse 'x '((3 1) (0 1))))
            (ys2(make-poly-from-sparse 'x '((3 1))))
            (ys3(make-poly-from-sparse 'x '((0 1))))
            )
        (test ys2 ys3)
        (test ys ys)
        (test yd yd)
        (test ys yd)
    )

)
(test-2.90)
    
    


