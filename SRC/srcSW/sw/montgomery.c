/*
 * montgomery.c
 *
 */

#include "montgomery.h"



//Add C to t array, starting from element i.
void customAdd(uint32_t *t,uint32_t i, uint32_t C){
    uint64_t sum;
    while (C!= 0)
    {
        sum = ((uint64_t) t[i]) +  ((uint64_t) C);
        C = (uint32_t) (sum>>32);
        t[i] = (uint32_t) sum;
        i = i+1;
    }
}

void customprintMont(uint32_t *in, char *str, uint32_t size)	{
    int32_t i;

    xil_printf("0x");
    for (i = size-1; i >= 0 ; i--) {
    	xil_printf("%9x", in[i]);
    }
    xil_printf("\n\r");
}



void condSubtract(uint32_t *n, uint32_t *res, uint32_t *t_prime, uint32_t size) {
    uint8_t i;
    uint32_t negative_carry = 0;
    for (i=0; i < size; i++) {
        res[i] = t_prime[i] - n[i] - negative_carry;
            if (t_prime[i] >= n[i]) {
                negative_carry = 0;
            } else {
                negative_carry = 1;
            }
        }
    if (negative_carry==1 && t_prime[size] == 0) { //b is greater than a
        for (i=0; i < size; i++) {
            res[i] = t_prime[i];
        }
    }
}


// Calculates res = a * b * r^(-1) mod n.
// a, b, n, n_prime represent operands of size elements
// res has (size+1) elements
void montMul(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *n_prime, uint32_t *res, uint32_t size)
{
uint32_t i;
uint32_t c;
uint32_t j;
uint64_t z;
uint64_t sum;
uint32_t length = 2*size + 1;
uint32_t t[length];
uint32_t t_prime[size + 1];

for(uint32_t k=0; k < length; k++){
	t[k] =0; // set elements of t to 0
}

for(i=0; i < size; i++){
		c=0;
		for(j=0; j < size; j++){
			sum    = ((uint64_t) t[i+j]) + ((uint64_t) a[j])*((uint64_t)b[i]) + ((uint64_t)c);
			c      = (uint32_t) (sum >> 32); //msb
			t[i+j] = (uint32_t) (sum); //lsb
		}
		t[i + size] = c;
}


/*for (i=03890; i < 64; i++) {
	res[i] = t[i];
}*/

for (i=0; i<size; i++){
    c =0;
    z =  (uint32_t) ( ((uint64_t) t[i])* ((uint64_t) n_prime[0]));
    for(uint32_t j=0; j<size; j++){
        sum = (uint64_t) t[i+j] + (uint64_t) ( ((uint64_t) z) * (uint64_t) n[j]) + ((uint64_t) c);
        c = (uint32_t) (sum>>32);
        t[i+j] = (uint32_t) sum;
    }
    customAdd(t,i+size,c);
	}


	//Perform the shift result by copying t into res.
for(uint32_t j=0; j<size+1; j++){
	t_prime[j] = t[j+size]; // Replaced res with t_prime, because res isn't final
		}

condSubtract(n, res, t_prime, size);

}

