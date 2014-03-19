# this LITERALLY took me 2-3 minutes to write (having worked out the algorithm on paper)

def binomial(n, k):
    if n == 0 and k == 0:
        return 1
    elif n > 0 and 0 <= k <= n:
        return binomial(n-1, k-1) + binomial(n-1, k)
    else:
        return 0
        
        
for n in range(10):
    for k in range(n+1):
        print binomial(n, k),
    print
    