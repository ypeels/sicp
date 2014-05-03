(load "ch5-compiler.scm")


(define (compile-to-file expr target linkage filename)
    (let (  (instruction-sequence (compile expr target linkage))
            (file (open-output-file filename #f)); second argument is append
            )
            
        ;(define (print x) (display x)) ; for testing
        (define (print x) (display x file))
        
        (define (display-result object-code-listing)
            (if (null? object-code-listing)
                'done
                (let ((current-line (car object-code-listing)))
                    (if (list? current-line)
                        (print "  ") ; get spacing right - statements are indented, but labels are not
                    )
                        
                    (print current-line)
                    (print "\n")
                    
                    (display-result (cdr object-code-listing))
                )
            )
        )

        
        (display-result (statements instruction-sequence))
        (close-all-open-files)
    )
   ( display "\nResults output to ") (display filename)
)
        


