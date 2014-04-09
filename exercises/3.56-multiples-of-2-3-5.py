### #    ; the stream solution seems like an awkward way of expressing a similar iterative algorithm
### #        ; twos = 2
### #        ; threes = 3
### #        ; fives = 5
### #        ; list = [1 2 3 5]
### #        ; iterate
### #            ; twos += 2 until it's greater than the current max
### #            ; threes += 3 similarly
### #            ; fives += 5 until it's greater than the current max
### #            ; list += min(twos threes fives)
### 
### # ok, this resulting code is LONGER, but it's much easier to understand - practically self-documenting
### 
### 
### 
### 
### # maybe there is a more pythonic way of doing this too...
### # oh i know, with generator expressions, which evaluate lazily, unlike listcomps?
### twos = 2
### threes = 3
### fives = 5   
### result = [1, 2, 3, 4, 5]                # data bug - i forgot to add 4.
### target_length = 50
### 
### while len(result) < target_length:
###     while twos <= result[-1]:           # kinda-subtle bug: had this as < instead of <= for a while. should've copied in my pseudo-code...
###         twos += 2
###     while threes <= result[-1]:
###         threes += 3
###     while fives <= result[-1]:
###         fives += 5
###         
###     #print "\tcurrent", result[-1], twos, threes, fives
###     result.append(min(twos, threes, fives))
###     print result[-1]






# wait, i misunderstood the PROBLEM. the numbers on the list must have NO OTHER prime factors other than 2, 3, or 5.
# thus, it's CORRECT that the scheme version doesn't output 14.
# there doesn't seem to be a clean way of doing this iteratively...? at least not without post-generation sorting...
# if you formulate as 2^a 3^b 5^c and enumerate upwards in (a, b, c), you still have to reorder the product somehow...
    # and it doesn't increase monotonically...
# then again, the stream "scheme" is doing "post-generation sorting" using (merge) anyway...

# the main problem is the mixing of the prime factors?


# ok, self-referentiality still seems like the way to go.
# start with list = [1]
# two_index = three_index = five_index = 0
    # 2 * list[two_index] = the smallest ELIGIBLE multiple of 2 that is not on the list
    
# iterate
    # list += min(2 * list[two_index], 3 * list[three_index], 5 * list[five_index])
    # increment all indices until values are greater than the end of the list
    # rinse and repeat
    
    

    
    
def two_value(index):
    return 2 * the_list[index]
def three_value(index):
    return 3 * the_list[index]
def five_value(index):
    return 5 * the_list[index]
    
def values_from_counters():
    return [two_value(i2), three_value(i3), five_value(i5)]
    
def update_counters():
    high_score = the_list[-1]
    global i2, i3, i5   # laziness
    while two_value(i2) <= high_score:  # increment them ALL to avoid repeats.
        i2 += 1
    while three_value(i3) <= high_score:
        i3 += 1
    while five_value(i5) <= high_score:
        i5 += 1
        
the_list = [1]
target_length = 50
#counters = [0, 0, 0]
i2 = i3 = i5 = 0        # if you WRITE to global variable in a def, it has to be declared global first. not so for read!
    
    

while len(the_list) < target_length:

    the_list.append(min(values_from_counters()))
    update_counters()
    print the_list[-1]
    

    # meh, too pythonic for me...
    # http://stackoverflow.com/questions/13300962/python-find-index-of-minimum-item-in-list-of-floats
    #new_value, new_index = min( (

# 0, (two_value, two_counter)
#enumerate(zip(candidate_values, counters))
#print new_value
#print new_index

# 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 27 30 32 36 40 45 48