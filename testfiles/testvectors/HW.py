import helpers

# Here we implement the three functions 
# that we implement in the hardware lab sessions.

# The mongomery multiplication, and exponentiation
# follow the pseudo code given in the slides,
# so that if needed students can debug
# their code by printing the intermediate values.

def MultiPrecisionAdd(A, B, addsub):
    # returns (A + B) mod 2^514 if   addsub == "add"
    #         (A - B) mod 2^514 else
    
    mask514  = 2**514 - 1
    mask515  = 2**515 - 1

    am     = A & mask514
    bm     = B & mask514

    if addsub == "add": 
        r = (am + bm) 
    else:
        r = (am - bm)
    
    return r & mask515  

def MontMul_512(A, B, M):
    # Returns (A*B*Modinv(R,M)) mod M
    C = 0
    for i in range(0,512):
        C = MultiPrecisionAdd(C, helpers.bit(A,i)*B, "add")
        if (C % 2) == 0:
            C = C / 2;
        else:
            C = MultiPrecisionAdd(C, M, "add") / 2;
    while C >= M:
        C = MultiPrecisionAdd(C, M, "sub")
    return C

def MontExp_512(X, E, M):
    # Returns (X^E) mod M
    R  = 2**512
    R2 = (R*R) % M;
    A  = R % M;
    X_tilde = MontMul_512(X,R2,M)
    t = helpers.bitlen(E)
    for i in range(0,t):
        A = MontMul_512(A,A,M)
        if helpers.bit(E,t-i-1) == 1:
            A = MontMul_512(A,X_tilde,M)
    A = MontMul_512(A,1,M)
    return A
