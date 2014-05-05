

;(define (compile-5.44 
    ; meh, just generalize (compile) and (compile-open-code) in 5.38, the way i did with ch5-compiler for lexical addressing




(load "ch5-compiler.scm") ; i wonder why this isn't included in load-eceval-compiler.scm
(load "load-eceval-compiler.scm")
(load "5.38-open-coded-primitive.scm")
;(load "5.39-lexical-address-lookup.scm") ; not using lexical addresses
(load "5.40-compile-time-env-in-lambda-body.scm") (install-compile-lambda-body-5.40) ; needed to extend the compile-time env
(load "5.41-find-variable-in-ct-env.scm") ; needed to traverse the compile-time env
;(load "5.42-lexical-address-integration.scm") (install-compile-var-set-5.42) ; not using lexical addresses

;(install-compile-5.38)

