import random

bits = 128

A = random.randrange(2**(bits-1), 2**bits-1)
B = random.randrange(2**(bits-1), 2**bits-1)

C = A + B

print "A     = ", hex(A)
print "B     = ", hex(B)
print "A + B = ", hex(C)