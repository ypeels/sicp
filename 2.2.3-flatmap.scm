; from ch1.scm (this really belongs in ch2support.scm)
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))
  

; from ch2.scm
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
          
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;: (accumulate append                                           ; flattens LL and concatentates to: ((2 1) (3 1) (3 2) ...). LL must be a LIST OF LISTS
;:             nil
;:             (map (lambda (i)                                 ; returns LL = ( ((2 1))  ((3 1) (3 2)) ... ((n 1)...(n n-1)) )
;:                    (map (lambda (j) (list i j))              ; returns L = ((i 1) (i 2) ... (i i-1))
;:                         (enumerate-interval 1 (- i 1))))
;:                  (enumerate-interval 1 n)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))
; 1. generates LL = (map proc seq) internally
; 2. reaches inside LL (which must be a LIST OF LISTS) and concatenates all its members using (append).
  

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (flatmap
                (lambda (i)
                  (map (lambda (j) (list i j))                  
                       (enumerate-interval 1 (- i 1)))) 
                (enumerate-interval 1 n)))))
                
                
(define (permutations s)
  (if (null? s)                         ; empty set?
      (list nil)                        ; sequence containing empty set
      (flatmap (lambda (x)
                 (map (lambda (p) (cons x p))
                      (permutations (remove x s))))
               s)))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))
                

                
(define (permutations s)
  (if (null? s)                         ; empty set?
      (list nil)                        ; sequence containing empty set
      (flatmap                              ; 1. map loops over each x in s, returning a list of permutations for each x
                                            ; 2. "flat" concatenates all the lists of permutations for the next iteration/recursion level
                                        
        (lambda (x)                         ; for EACH x in s
            (map                            ; generate a list
                (lambda (p) (cons x p))     ; where you have tacked x to the beginning of all the members of
                (permutations (remove x s)) ; the permutations of s - x
            )
        )
        s
      )
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ok, so the basic algorithm is to
; LOOP over every x in S
    ; prepend x to all permutations of (S-x)
    ; this gives you all permutations STARTING WITH x
; since you loop over EVERY x in S, 
    ; this gives you all permutations starting with every x in S
    ; i.e., all permutations of S, full stop.
; example: s = (1)
    ; (permutations s)
    ; = (flatmap (lambda (x) (map (lambda (p) (cons x p)) (permutations ()))) (1))
    ; = (flatmap (lambda (x) (map (lambda (p) (cons x p))      (())        )) (1))
    ; = (flatmap (lambda (x)                                   ((x))       )) (1))
    ; = (accumulate append nil (map ( lambda (x) ((x)) ) (1)))  ; where ((x)) is shorthand for (list (list x))
    ; = (accumulate append nil (((1))))
    ; = ((1)).
    ; you can see here that (map) instead of (flatmap) would add a level of nesting.
; example: s = (1 2)
    ; (permutations (1 2))
    ; = (flatmap (lambda (x) (map (lambda (p) (cons x p)) (permutations (remove x s))) (list 1 2))
        ; lambdas evaluate from outside in, but regular expressions evaluate from inside out?
        ; x = 1:    (map (lambda (p) (cons 1 p)) (permutations (remove 1 (1 2))))
            ; =     (map (lambda (p) (cons 1 p)) (permutations      ((2))      ))
            ; =     (map (lambda (p) (cons 1 p))                    ((2))       )
            ; =                                ((1 2))
        ; similarly, x = 2 case yields         ((2 1))
    ; = (accumulate append nil ( ((1 2)), ((2 1)) ))
    ; = ((1 2), (2 1)).
; example: s = (1 2 3)
    ; x = 1: prepend x to (2 3) and (3 2) to yield (1 2 3) (1 3 2)
    ; x = 2: prepend x to (1 3) and (3 1) to yield (2 1 3) (2 3 1)
    ; x = 3: prepend x to (1 2) and (2 1) to yield (3 1 2) (3 2 1)

; these recursive algorithms seem easiest/most natural to prove/understand by induction...
; also, this doesn't seem like something i'd come up with very naturally...

    
               

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))
                
  
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                
                
; new support and testing code                
(define nil ())

(define L (list 1 2 3))

(display "\nmap: ") 
(display (map square L))    
; (1 4 9)

(display "\nflatmap: ") 
(display 
    (flatmap 
        (lambda (x) 
            (list (square x))   ; <------- NOT the same as in map!!!
        ) 
        L
    )
)   
; (1 4 9)

(newline) (display (enumerate-interval 1 7))


; how about a convenience form?
(define (all-pairs n)
    (flatmap                                         ; 
                (lambda (i)
                  (map (lambda (j) (list i j))                  
                       (enumerate-interval 1 (- i 1)))) 
                (enumerate-interval 1 n))
)


(newline) (display (all-pairs 7))
(display "\nbook: ") (display (map make-pair-sum (filter prime-sum? (all-pairs 6)))) 
(display "\nflip: ") (display (filter prime-sum? (map make-pair-sum (all-pairs 6))))    ; yep, order of map and filter doesn't matter in this case! (at least w.r.t. correctness)


(define (test-perm n)
    (newline)
    (display n)
    (newline)
    (display (permutations (enumerate-interval 1 n)))
    (newline)
)
(test-perm 1)
(test-perm 2)
(test-perm 3)
(test-perm 4)



; flatmap != map!!!!
    ; proc in (map proc seq) returns scalars
    ; proc in (flatmap proc seq) returns LISTS
        ; this is because APPEND ONLY OPERATES ON LISTS.
        

        

