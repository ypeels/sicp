; suppose (halts?) "correctly determines whether p halts [or terminates without error] on a for any procedure p and object a"

(define (run-forever) (run-forever))

(define (try p)
  (if (halts? p p)
      (run-forever)
      'halted))
      
; now be perverse and invoke (try try)
    ; if this runs forever, that means (halts? (try try)) was true, yet (try try) does NOT halt.
    ; if this returns 'halted, that means (halts? (try try)) was false, yet (try try) DOES halt.
    
; the hypothesis must be incorrect - there can be no such (halts?) that works on ALL procedures p and arguments a.
    ; this self-referential argument seems very similar to Godel's construction of the Epimenides paradox
    ; "This sentence is false"
    ; "This procedure will halt if it does not halt."