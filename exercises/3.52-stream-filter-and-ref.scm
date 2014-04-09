; from ch3.scm
(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x)
  (newline)
  (display x))
(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))  

; my new utility function
(define (probe)
    (display "\n\tprobe: ") (display sum))
  
; from problem statement (added display statements)
(define sum 0)
(probe)         ; 0

(define (accum x)
  (set! sum (+ x sum))
  sum)
(probe)         ; 0
  
  
; Footnote 59: "Exercises such as 3.51 and 3.52 are valuable for testing our understanding of how delay works.
; On the other hand, intermixing delayed evaluation with printing -- and, even worse, with assignment -- 
; is extremely confusing... writing programs that depend on such subtleties is odious programming style."
    ; hmm, seemed kinda straightforward to me... maybe the example is oversimplified?
    ; or maybe a true Schemer's mind really is that twisted...
    ; ohhh the REAL confusion sets in when you have to consider un-memoized streams...
(define seq (stream-map accum (stream-enumerate-interval 1 20)))    
(probe)         ; 1
                ; seq: (1 . #promise)

(define y (stream-filter even? seq))
(probe)         ; 6
                ; seq: (1 . (3 . (6 . #promise))) 
                ; because stream-filter evaluates all the way to its first entry

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
(probe)         ; 10
                ; seq: (1 . (3 . (6 . (10 . #promise))))
                         
(stream-ref y 7)
(probe)         ; 136
                ; seq: (1 . (3 . (6 . (10 . (15 . (21 . (28 . (36 . (45 . (55 . (66 . (78 . (91 . (105 . (120 . (136 . #promise...)
                ; y : (6 . (10 . (28 . (36 . (66 . (78 . (120 . (136 . #promise))))))))
                    ; evaluates y all the way to the 8th triangular number
                    ; this requires seq all the way out to 136 (stream-ref seq 15)

(display-stream z)
; 10
; 15
; 45
; 55
; 105
; 120
; 190
; 210
(probe)         ; 210. this is because (display-stream) causes the ENTIRE stream to be evaluated.


; and i added this for kicks
(display-stream seq)
; 1
; 3
; 6
; 10
; 15
; 21
; 28
; 36
; 45
; 55
; 66
; 78
; 91
; 105
; 120
; 136
; 153
; 171
; 190
; 210

; uh, what would happen without memoization?
; from the text, if you ever have to force the result again, then accum will be called again...
; from the definition of (cons-stream), the very first term would be set in stone, but all other terms would be re-evaluated!

; (define y): sum = 6 still, i think...
; (define z): sum STARTS at 6, and seq goes to (1 . 8 . 11 . 20) and stops, so sum will be 20?
; etc. i really don't want to work through this stupidity... the answer is YES, most of these responses will differ.
    ; the reason is that accum will be re-evaluated, and now with sum taking on "incorrect" starting values.