(load "2.40-unique-pairs.scm")

(define (unique-triples-with-k k)

    (define (triple-with-k pair)    ; analagous to (pair-with-i)
        (cons k pair))
        
    (map 
        triple-with-k
        (unique-pairs (- k 1))      ; ahhhh now isn't that clean!? 
    )
)




; (display (unique-triples-with-k 5)); brief testing


(define (unique-triples n)

    ;(map
    (flatmap                        ; the (accumulate) in (flatmap) has the side effect of removing any ()'s from the list
        unique-triples-with-k
        (enumerate-interval 1 n)
    )
)

; (display (unique-triples 5))




(define (unique-triples-with-sum n s)   ; now THIS is crystal clear to me!!!
    (define (sum seq)
        (accumulate + 0 seq))
        
    (define (sums-to-s? seq)
        (= s (sum seq)))        

    (filter
        sums-to-s?
        (unique-triples n)
    )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; now just how monstrous will this be with lambdas (i.e., no subroutine names, except maybe unique-pairs)?


; k > i > j
; this is due to the unfortunate convention used in (prime-sum-pairs)
(define (unique-triples-with-sum-lambda n sum)

    ; you have to write this shit from the INSIDE OUT to make sense of it...
        ; assume k is known
            ; apply "unique-triples-with-k" to (unique-pairs)
        ; then wrap the whole thing with (lambda (k)) 
            ; the value of k comes from applying this lambda to something
            
    ; writing this way does NOT seem much harder, although it is counter-intuitive
        ; but READING these things seems like it would be much much harder...
            
        
    (filter                                         ; selects only those triples that add to sum
        (lambda (seq) 
            (= sum (accumulate + 0 seq))
        )
        
        (flatmap                                    ; generates "unique-triples" (k i j) with n >= k > i > j >= 1
            (lambda (k)
                (map 
                    (lambda (pair) (cons k pair))
                    (unique-pairs (- k 1))
                )
            )
            (enumerate-interval 1 n)
        )
        
        
        ; alternatively, write out (unique-pairs) in lambda form, and cycle indices...
        ; sadly, i BET this is what the authors intended...
        ; http://community.schemewiki.org/?sicp-ex-2.41 looks a bit cleaner using one big list instead of appending with cons...
        
        ;(flatmap
        ;    (lambda (i)
        ;        (flatmap                                ; "map" to loop over j, "flat" to merge all results
        ;            (lambda (j)
        ;                (map 
        ;                    (lambda (k)
        ;                        (list i j k)
        ;                    )
        ;                    (enumerate-interval 1 (- j 1))
        ;                )
        ;            )
        ;            (enumerate-interval 1 (- i 1))
        ;        )
        ;    )
        ;    (enumerate-interval 1 n)
        ;)
        
        ; and here's the same thing with more Scheming indentation, line spacing, and close parens. less ugly but much more confusing to write...
        ;(flatmap 
        ;    (lambda (i)
        ;    (flatmap 
        ;        (lambda (j)
        ;            (map    (lambda (k) (list i j k))
        ;                    (enumerate-interval 1 (- j 1))))
        ;        (enumerate-interval 1 (- i 1))))
        ;    (enumerate-interval 1 n))
    )
)








(define (test-2.41)

    (define (test n sum) 
        (newline) (display (unique-triples-with-sum n sum))
        (newline) (display (unique-triples-with-sum-lambda n sum))
    )
    
    (test 10 21)
    
)

; (test-2.41)
        