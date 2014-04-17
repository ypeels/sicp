(define (install-yacht-puzzle)
    (ambeval-batch
    
    
        '(define (yacht-puzzle-efficient)
            
            ; meh, hard-coded pruning is ERROR PRONE. oh, and you can vary this more easily too!
            (let ((mary (amb 'downing 'hall 'hood 'moore 'parker)))
                (require (eq? mary 'moore))
                (let ((melissa (amb 'downing 'hall 'hood 'moore 'parker)))
                    (require (eq? melissa 'hood))
                    (require (not (eq? melissa mary))) ; hey, you can enforce (distinct?) this way!
                    (let ((rosalind (amb 'downing 'hall 'hood 'moore 'parker)))
                        (require (not (eq? rosalind 'hall)))
                        (require (not (eq? rosalind mary)))
                        (require (not (eq? rosalind melissa)))
                        (let ((lorna (amb 'downing 'hall 'hood 'moore 'parker)))
                            (require (not (eq? lorna 'moore)))
                            (require (not (eq? lorna mary)))
                            (require (not (eq? lorna melissa)))
                            (require (not (eq? lorna rosalind)))
                            (let ((gabrielle (amb 'downing 'hall 'hood 'moore 'parker)))
                                (require (not (eq? gabrielle 'hood)))
                                (require (not (eq? gabrielle 'parker)))
                                (require (not (eq? gabrielle mary)))
                                (require (not (eq? gabrielle melissa)))
                                (require (not (eq? gabrielle rosalind)))
                                (require (not (eq? gabrielle lorna)))
                                
                                
                                ; "Gabrielle's father owns the yacht that is named after Dr. Parker's daughter."
                                (require
                                    (cond
                                        ((eq? gabrielle 'downing) (eq? melissa 'parker)) ; this one contradicts Melissa Hood above
                                        ((eq? gabrielle 'hall) (eq? rosalind 'parker))
                                        ((eq? gabrielle 'hood) (eq? gabrielle 'parker)) ; we already knew Hood owns Gabrielle
                                        ((eq? gabrielle 'moore) (eq? lorna 'parker))
                                        ;((eq? gabrielle 'parker) false) ; patently false (not sure what it maps to...since we don't know parker's yacht's name
                                    )
                                )
                                
                                (list 
                                    (list 'gabrielle gabrielle )
                                    (list 'lorna lorna)
                                    (list 'mary mary)
                                    (list 'melissa melissa)
                                    (list 'rosalind rosalind)
                                )
                                
                                
                            )
                        )
                    )
                )
            )
        )
                        

        
        ; less efficient, but easier to vary constraints.
        '(define (yacht-puzzle-brute)
        
            ; currently enumerating by girl's last name. that makes the last sentence hard...?
            (let (  (gabrielle (amb 'downing 'hall 'hood 'moore 'parker))
                    (lorna (amb 'downing 'hall 'hood 'moore 'parker))
                    (mary (amb 'downing 'hall 'hood 'moore 'parker))                    
                    (melissa (amb 'downing 'hall 'hood 'moore 'parker))
                    (rosalind (amb 'downing 'hall 'hood 'moore 'parker))
                    )
                (require (eq? mary 'moore))
                (require (not (eq? gabrielle 'hood)))
                (require (not (eq? lorna 'moore)))
                (require (not (eq? rosalind 'hall)))
                (require (not (eq? melissa 'downing)))
                (require (eq? melissa 'hood))
                (require (not (eq? gabrielle 'parker)))
                
                
                
                
                (require (distinct? (list gabrielle lorna mary melissa rosalind)))
                
                ; as formulated above, there are 3 solutions...(Gabrielle, Lorna, Mary, Melissa, Rosalind) =
                    ; (downing, hall, moore, hood, parker)
                    ; (hall, downing, moore, hood, parker)
                    ; (hall, parker, moore, hood, downing)
                    
                ; oh, i need to parse the last sentence a BIT more carefully...?
                ; gabrielle's father: we know that's downing or hall.
                    ; but we KNOW what boats they have - melissa and rosalind, respectively.
                    ; then again, if we want to be "brute", we shouldn't code that in...
                ; "through association"?
                
                ; "Gabrielle's father owns the yacht that is named after Dr. Parker's daughter."
                (require
                    (cond
                        ((eq? gabrielle 'downing) (eq? melissa 'parker)) ; this one contradicts Melissa Hood above
                        ((eq? gabrielle 'hall) (eq? rosalind 'parker))
                        ((eq? gabrielle 'hood) (eq? gabrielle 'parker)) ; we already knew Hood owns Gabrielle
                        ((eq? gabrielle 'moore) (eq? lorna 'parker))
                        ;((eq? gabrielle 'parker) false) ; patently false (not sure what it maps to...since we don't know parker's yacht's name
                    )
                )
                        
                
                
                
                (list 
                    (list 'gabrielle gabrielle )
                    (list 'lorna lorna)
                    (list 'mary mary)
                    (list 'melissa melissa)
                    (list 'rosalind rosalind)
                )
            )
        )
         

        '(define e yacht-puzzle-efficient)  ; runs noticeably faster.
        '(define b yacht-puzzle-brute)
    
    )
)

(define (test-4.43)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.38-44-distinct.scm")
    (install-distinct)
    
    (install-yacht-puzzle)
    
    
    (driver-loop)
)
(test-4.43)


; Gabrielle Hall, Lorna Downing, Mary Ann Moore, Melissa Hood, Rosalind Parker.

; if Mary's last name is unspecified... there is ONE more solution
; Gabrielle Moore, Lorna Parker, Mary Ann Hall, Melissa Hood, Rosalind Downing.