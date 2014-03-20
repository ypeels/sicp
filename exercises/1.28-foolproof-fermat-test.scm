; Miller-Rabin test
; during the squaring step in expmod, check for a nontrivial sqrt of 1 mod n
    ; if found, then n is not prime
    ; "for at least half the numbers a < n, computing a^(n-1) this way will reveal a nontrivial sqrt of 1" [assuming n is not prime?]
        ; this second guarantees that if you keep testing enough random a's, 
        ; you can determine with arbitrarily high certainty whether n is prime
    ; if fermat test passes, the probability of a false positive is p < 0.5
    ; run K tests to make p^K "arbitrarily" small (only really feasible for LARGE n, but that's the case that matters anyway)
    
    
    ; check it on carmichael numbers!!