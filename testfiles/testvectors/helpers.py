import binascii
import random
import math

import sys
sys.setrecursionlimit(1500)

def setSeed(seedInput):
    random.seed(seedInput)

def getModuli(bits):
    N = 1
    while bitlen(N) != bits*2:
        p     = getRandomPrime(bits)
        q     = getRandomPrime(bits)
        N     = p*q
    return [p,q,N]

def getModulus(bits):
    n = random.randrange(2**(bits-1), 2**bits-1)
    # print gcd(n, 2**bits)
    while not gcd(n, 2**bits) == 1:
        n = random.randrange(2**(bits-1), 2**bits-1)
    mod = n
    return n

def getRandomMessage(bits,M):
    return random.randrange(2**(bits-1), M); 

def getRandomMessageForCRT(p,q):
    if p < q:
        M = p
    else:
        M = q
    return random.randrange(M); 

def getRandomPrime(bits):
    n = random.randrange(2**(bits-1), 2**bits-1)
    while not isPrime(n):
        n = random.randrange(2**(bits-1), 2**bits-1)
    return n

def getRandomInt(bits):
    return random.randrange(2**(bits-1), 2**bits-1)

def getRandomExponents(p, q):
    phi = (p-1)*(q-1)
    e = getRandomPrime(16)
    while not gcd(e, phi) == 1:
        e = getRandomPrime(16)
    d = Modinv(e,phi)
    return [e,d]

def isPrime(n, k=5): # miller-rabin
    from random import randint
    if n < 2: return False
    for p in [2,3,5,7,11,13,17,19,23,29]:
        if n % p == 0: return n == p
    s, d = 0, n-1
    while d % 2 == 0:
        s, d = s+1, d/2
    for i in range(k):
        x = pow(randint(2, n-1), d, n)
        if x == 1 or x == n-1: continue
        for r in range(1, s):
            x = (x * x) % n
            if x == 1: return False
            if x == n-1: break
        else: return False
    return True

def bitlen(n):
    return int(math.log(n, 2)) + 1

def bit(y,index):
  bits   = [(y >> i) & 1 for i in range(1024)]
  bitstr = ''.join([chr(sum([bits[i * 8 + j] << j for j in range(8)])) for i in range(1024/8)])
  return (ord(bitstr[index/8]) >> (index%8)) & 1

def gcd(x, y):
    while y != 0:
        (x, y) = (y, x % y)
    return x

def Modexp(b,e,m):
  if e == 0: return 1
  t = Modexp(b,e/2,m)**2 % m
  if e & 1: t = (t*b) % m
  return t

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def Modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        return -1
    else:
        return x % m

def WriteConstants(number, size):

    out = ''

    for i in range(size):
        out += '0x{:08x}'.format(number & 0xFFFFFFFF)
        number >>= 32
        out += ', ' if i<(size - 1) else ''
    return out

def CreateConstants(M, p, q, N, e, d_p, d_q, x_p, x_q, Rp, Rq, R2p, R2q, R_1024, R2_1024, seed):
    target = open("./testvector.c", 'w')
    target.truncate()

# extern uint32_t M[32], 
#                 N[32],       N_prime[32],
#                 e[32],       
#                 e_len,       
#                 p[16],       q[16],      
#                 d_p[16],     d_q[16],    
#                 d_p_len[16], d_q_len[16],    
#                 x_p[32],     x_q[32],    
#                 R2p[16],     R2q[16],    
#                 R_1024[32],  R2_1024[32],
#                 One[32];          

    r = 2**1024                      
    N_prime = (r - Modinv(N, r))

    target.write(
    "#include <stdint.h>                                              \n" +
    "                                                                 \n" +
    "// This file's content is created by the testvector generator    \n" +
    "// python script for seed = " + str(seed) + "                    \n" +
    "//                                                               \n" +
    "//  The variables are defined for the RSA                        \n" +
    "// encryption and decryption operations. And they are assigned   \n" +
    "// by the script for the generated testvector. Do not create a   \n" +
    "// new variable in this file.                                    \n" +
    "//                                                               \n" +
    "// When you are submitting your results, be careful to verify    \n" +
    "// the test vectors created for seed = 2017.1, to 2017.5         \n" +
    "// To create them, run your script as:                           \n" +
    "//   $ python testvectors.py crtrsa 2017.1                       \n" +
    "                                                                 \n" +
    "// message                                                       \n" +
    "uint32_t M[32] = {" + WriteConstants(M,32) + "};                 \n" +
    "                                                                 \n" +
    "// prime p and q                                                 \n" +
    "uint32_t p[16] = {" + WriteConstants(p,16) + "};                 \n" +
    "uint32_t q[16] = {" + WriteConstants(q,16) + "};                 \n" +
    "                                                                 \n" +
    "// modulus                                                       \n" +
    "uint32_t N[32]       = {" + WriteConstants(N,32) + "};           \n" +
    "uint32_t N_prime[32] = {" + WriteConstants(N_prime,32) + "};     \n" +
    "                                                                 \n" +
    "// encryption exponent                                           \n" +
    "uint32_t e[32] = {" + WriteConstants(e,1) + "};                  \n" +
    "uint32_t e_len = 16;                                             \n" +
    "                                                                 \n" +
    "// decryption exponent, reduced to p and q                       \n" +
    "uint32_t d_p[16] = {" + WriteConstants(d_p,16) + "};             \n" +
    "uint32_t d_q[16] = {" + WriteConstants(d_q,16) + "};             \n" +
    "uint32_t d_p_len =  " + str(int(round(math.log(d_p, 2)))) + ";   \n" +
    "uint32_t d_q_len =  " + str(int(round(math.log(d_q, 2)))) + ";   \n" +
    "                                                                 \n" +
    "// x_p and x_q                                                   \n" +
    "uint32_t x_p[32] = {" + WriteConstants(x_p,32) + "};             \n" +
    "uint32_t x_q[32] = {" + WriteConstants(x_q,32) + "};             \n" +
    "                                                                 \n" +
    "// R mod p, and R mod q, (R = 2^512)                             \n" +
    "uint32_t Rp[16]  = {" + WriteConstants(Rp,16) + "};              \n" +
    "uint32_t Rq[16]  = {" + WriteConstants(Rq,16) + "};              \n" +
    "                                                                 \n" +
    "// R^2 mod p, and R^2 mod q, (R = 2^512)                         \n" +
    "uint32_t R2p[16] = {" + WriteConstants(R2p,16) + "};             \n" +
    "uint32_t R2q[16] = {" + WriteConstants(R2q,16) + "};             \n" +
    "                                                                 \n" +
    "// R mod N, and R^2 mod N, (R = 2^1024)                          \n" +
    "uint32_t R_1024[32]  = {" + WriteConstants(R_1024 ,32) + "};     \n" +
    "uint32_t R2_1024[32] = {" + WriteConstants(R2_1024,32) + "};     \n" +
    "                                                                 \n" +
    "// One                                                           \n" +
    "uint32_t One[32] = {1,0};                                          " )

    target.close()