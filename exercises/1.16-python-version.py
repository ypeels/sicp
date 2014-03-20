'''how fast can i whip up a "fast" algorithm of my design in python??'''


def fast_expt_iter(base, exponent):
    '''returns base ** exponent in logarithmic time
    
    Maintains a lookup table of [base, base^2, base^4, ...] 
    to use a really simple algorithm .
    
    This script took 16 min from start to finish, and took VERY LITTLE CREATIVITY
    It also appears to be very easy to read
    
    Contrast this with the Scheme version,
    where restrictive storage/language constraints forced HOURS of working through
    their solution method on pencil/paper...
    '''

    if exponent <= 0:
        return 1
    

    # (how) could you do this with a listcomp? serial dependence...
    square_bank = []
    x = base
    n = 1
    while n <= exponent:
        square_bank.append((n, x))
        x = x**2
        n *= 2
        
    #print square_bank
 

    result = 1
    for ex, value in reversed(square_bank):
        if exponent >= ex:     # used to be a "while", to be extra-safe
            exponent -= ex
            result *= value
            
    
    
    return result
    
    
# see, the great thing about python is that you can TEST scripts immediately AND thoroughly
# it's just EASIER TO USE
if __name__ == "__main__":
    print fast_expt_iter(2, 5)
    
    for b in range(2, 10):
        for ex in range(15):
            y = fast_expt_iter(b, ex)
            assert(b**ex == y)
            print b, "**", ex, "=", y