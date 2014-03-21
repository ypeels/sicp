; Miller-Rabin test
; during the squaring step in expmod, check for a nontrivial sqrt of 1 mod n
    ; if found, then n is not prime
    ; "for at least half the numbers a < n, computing a^(n-1) this way will reveal a nontrivial sqrt of 1" [assuming n is not prime?]
        ; this second guarantees that if you keep testing enough random a's, 
        ; you can determine with arbitrarily high certainty whether n is prime
    ; if fermat test passes, the probability of a false positive is p < 0.5
    ; run K tests to make p^K "arbitrarily" small (only really feasible for LARGE n, but that's the case that matters anyway)
    
    
    


; need to rewrite (expmod), so there's no point to loading any old code?
; no, (fermat-test) and (fast-prime?) are still useful
(load "1.24-25-fast-prime-by-fermat.scm")

; override!
(define (expmod base ex m)
  (cond ((= ex 0) 1)
        ((even? ex)        
         (mod-square-and-check (expmod base (/ ex 2) m) m))      ; <---- custom squaring function
        (else
         (remainder (* base (expmod base (- ex 1) m))
                    m))))



; returns x^2 mod m, with an...
; EXCEPTION: this function returns 0 if x^2 = 1 mod m, and x is neither 1 nor m-1 (trivial sqrts)
(define (mod-square-and-check x m)
    (define x-sq-mod-m (remainder (square x) m))
    (if 
        (and 
            (= x-sq-mod-m 1) 
            (not (= x 1)) 
            (not (= x (- m 1))))
        0                           ; the exception. definitely true that 0 != a, so this auto-fails the miller-rabin test
        x-sq-mod-m))


        
                    
; check it on carmichael numbers!!
(define (f n) 
    (newline)
    (display n)
    (if (fast-prime? n 100)
        (display " is prime? (passed miller-rabin test)")
        (display " is composite! (failed miller-rabin test)")))
   
; carmichael numbers - should read as composite   
(f 561) 
(f 1105)
(f 1729)
(f 2465)
(f 2821)
(f 6601)

; primes
(f 751)
(f 997)
(f 10000000061)