import helpers

# Here we don't implement the functions 
# as the students should implement them
# in their software lab sessions

def MontMul_1024(A, B, M):
    # Returns (A*B*Modinv(R,M)) mod M
    R = 2**1024
    return (A*B*helpers.Modinv(R,M)) % M
    
def MontExp_1024(A, e, M):
    # Returns A^e mod M
    return helpers.Modexp(A,e,M)    # This is fast
    # return A**e % M               # This is slow