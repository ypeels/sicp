(load "3.66-72-streams-of-pairs.scm")

; from ch3.scm
(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))
    

(define (test-3.66)

    (define (examine-pair? pair)
        (let ((s (car pair)) (t (cadr pair)))
        
            ;(= t 5)
            ;(and (= t 100)
                (or (= s t) (= s (- t 1)))
            ;(= s t)
            ;)
            
        
        )
    )

        
    (let (  (int-pairs (pairs integers integers))
            (num-pairs 100000)
            )
            
        (define (iter i)
            
            ; cheat and just scan for particular entries
            
            (let ((current-pair (stream-ref int-pairs i)))
                (if (examine-pair? current-pair)
                    (begin
            
                        (newline)
                        (display i) (display "\t")
                        (display current-pair)
                    )
                )
            )
            
            (if (< i num-pairs)
                (iter (+ i 1)))
        )
        (iter 0)
    )
)
;(test-3.66)

; summary of EMPIRICAL results
    ; (1, 100) is preceded by 197 pairs.
    ; (100, 100) is preceded by 2**100 - 2 pairs which is about 10**33.
    ; (99, 100) is preceded by (2**100 - 2) - 2**98 pairs.
    
    ; respective lemmas - nay, conjectures
    ; pair (1, k) is pair number (2k-3), zero-indexed.
    ; there are 2**(k-2) pairs between (k-1, k) and (k, k)
    ; (k, k) is preceded by 2**k - 2 pairs.
    
; what do sols have to say?
    ; they draw out a table, and the diagonal, 1-off-diagonal elements seem to follow this pattern
    ; MAYBE even 2-off-diagonal? 
    ; but there does not seem to be any discernible pattern in the table interior...

    
; hunting for (100, 100)
; 0         (1 1)
; 2         (2 2)
; 6         (3 3)
; 14        (4 4)
; 30        (5 5)
; 62        (6 6)
; 126       (7 7)
; 254       (8 8)
; 510       (9 9)
; 1022      (10 10)
; 2046      (11 11)
; 4094      (12 12)
; 2**k - 2  (k k)

; hunting for (99, 100) and (100, 100)
; 1 to 2    (1 2) to (2 2)
; 4 to 6    (2 3) to (3 3)
; 10 to 14  (3 4) to (4 4)
; 22 to 30  (4 5) to (5 5)
; 46 to 62  (5 6) to (6 6)
; ...
; 24574 to 32766 (14 15) to (15 15) - difference of 8192 = 2**13
; 49150 to 65534 (15 16) to (16 16) - difference of 16384 = 2**14
; 98302 to 131070 (16 17) to (17 17)- difference of 32768 = 2**15

; here's raw data if you want it...
; 1 1   pair 0
; 1 2   pair 1
; 2 2
; 1 3   pair 3
; 2 3   pair 4
; 1 4   pair 5. so (1, k) is pair (2k-3), and (1, 100) is preceded by 197 pairs. that one was easy...
; 3 3
; 1 5
; 2 4
; 1 6
; 3 4   pair 10
; 1 7
; 2 5
; 1 8
; 4 4   pair 14
; 1 9
; 2 6
; 1 10
; 3 5
; 2 7
; 1 12
; 4 5   pair 22
; 1 13
; 2 8
; 1 14
; 3 6
; 1 15
; 2 9
; 1 16
; 5 5   pair 30
; 1 17
; 2 10
; 1 18
; 3 7
; 1 19
; 2 11
; 1 20
; 4 6   pair 38
; 1 21 
; 2 12
; 1 22
; 3 8
; 1 23
; 2 13
; 1 24
; 5 6   pair 46 
; 1 25
; 2 14
; 1 26
; 3 9
; 1 27
; 2 15
; 1 28
; 4 7
; 1 29
; 2 16
; 1 30
; 3 10
; 1 31
; 2 17
; 1 32
; 6 6   pair 62 - SEEMS like there are 2**(j-2) pairs between (j-1, j) and (j, j).

            
    
        