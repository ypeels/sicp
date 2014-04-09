#    ; the stream solution seems like an awkward way of expressing a similar iterative algorithm
#        ; twos = 2
#        ; threes = 3
#        ; fives = 5
#        ; list = [1 2 3 5]
#        ; iterate
#            ; twos += 2 until it's greater than the current max
#            ; threes += 3 similarly
#            ; fives += 5 until it's greater than the current max
#            ; list += min(twos threes fives)

# ok, this resulting code is LONGER, but it's much easier to understand - practically self-documenting


# maybe there is a more pythonic way of doing this too...
# oh i know, with generator expressions, which evaluate lazily, unlike listcomps?
twos = 2
threes = 3
fives = 5   
result = [1, 2, 3, 4, 5]                # data bug - i forgot to add 4.
target_length = 50

while len(result) < target_length:
    while twos <= result[-1]:           # kinda-subtle bug: had this as < instead of <= for a while. should've copied in my pseudo-code...
        twos += 2
    while threes <= result[-1]:
        threes += 3
    while fives <= result[-1]:
        fives += 5
        
    #print "\tcurrent", result[-1], twos, threes, fives
    result.append(min(twos, threes, fives))
    print result[-1]





