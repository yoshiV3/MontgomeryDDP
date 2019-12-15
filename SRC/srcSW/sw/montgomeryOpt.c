/*
 * montgomeryOpt.c
 *
 *  Created on: Oct 16, 2019
 *      Author: r0666113
 */



#include "montgomeryOpt.h"
#include "asm_montgomeryOpt.h"
#include "string.h"





//Add C to t array, starting from element i.
void customAddOpt(uint32_t *t,uint32_t i, uint32_t C){
    uint64_t sum;
    while (C!= 0)
    {
        sum = ((uint64_t) t[i]) +  ((uint64_t) C);
        C = (uint32_t) (sum>>32);
        t[i] = (uint32_t) sum;
        i = i+1;
    }
}




void condSubtractOpt(uint32_t *n, uint32_t *res, uint32_t *t_prime, uint32_t size) {
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
    if (negative_carry==1 && t_prime[size] == 0) { //xil_printf("Computed");b is greatxil_printf("\n\r");er than a
        for (i=0; i < size; i++) {
            res[i] = t_prime[i];
        }
    }
}

void condSubtractOpt2(uint32_t *n, uint32_t *res, uint32_t *t_prime, uint32_t size) {
	uint8_t i;
	uint8_t k;
	uint32_t negative_carry = 0;
	uint8_t bool = t_prime[size];
	for (i = size; i > 0; i--) {
		if(bool || t_prime[i-1] > n[i-1]) {
			bool = 1;
			res[i-1] = t_prime[i-1] - n[i-1] - negative_carry;
			if (t_prime[i-1] >= n[i-1]) {
			    negative_carry = 0;
			} else {
			    negative_carry = 1;
			}
		} else if (t_prime[i-1] == n[i-1]) { // don't set bool, it can go either way
			res[i-1] = t_prime[i-1] - n[i-1] - negative_carry;
			if (t_prime[i-1] >= n[i-1]) {
			    negative_carry = 0;
			} else {
			    negative_carry = 1;
			}
		} else {
			copy(t_prime, res, size);
			return;
//			for (k=0; k < size; k++) {
//			    res[k] = t_prime[k];
//			}

		}
	}

}

void customprintMontOpt(uint32_t *in, char *str, uint32_t size)	{
    int32_t i;

    xil_printf("0x");
    for (i = size-1; i >= 0 ; i--) {
    	xil_printf("%8x", in[i])	;
    }
    xil_printf("\n\r");
}

// Calculates res = a * b * r^(-1) mod n.
// a, b, n, n_prime represent operands of size elements
// res has (size+1) elements
void montMulOpt(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *n_prime, uint32_t *res, uint32_t size)
{
uint32_t i;
//uint32_t j;
//uint64_t sum;
uint32_t length = 2*size + 1;
uint32_t t[length];
//uint32_t * t_prime;
uint32_t * t_pointer;
//START_TIMING
clear(t, size);
//customprintMontOpt(t, "65", length);
//STOP_TIMING
for(i=0; i < size; i++){
		multiplication(a, b, t, i, size);
//		c=0;
//		for(j=0; j < size; j++){
//			sum    = ((uint64_t) t[i+j]) + ((uint64_t) a[j])*((uint64_t)b[i]) + ((uint64_t)c);
//			c      = (uint32_t) (sum >> 32); //msb
//			t[i+j] = (uint32_t) (sum); //lsb
//		}
//		t[i + size] = c;
}

/*for (i=0; i < 64; i++) {
	res[i] = t[i];
}*/

//customprintMont(t, "res", 32);
 //6400 cycli

for (i=0; i<size; i++){ //358 per cycle total
	reduction(n, n_prime, t, i, size);

}

	//700 cycli
	//Perform the shift result by copying t into res.
//	START_TIMING
//	for(uint32_t j=0; j<size+1; j++){
//		t_prime[j] = t[j+size]; // Replaced res with t_prime, because res isn't final
//			}
//	STOP_TIMING
	t_pointer = t;
	t_pointer += (size); // I think the compiler shift size by 2
	//customprint(t_prime, "res", 33);
	//300 cycli

	condSubtractOpt(n, res, t_pointer, size);

}

void exponentation(uint32_t *x, uint32_t *r, uint32_t *r2, uint32_t *e,uint32_t el, uint32_t *n,uint32_t *n_prime, uint32_t *aCapital, uint32_t size){
	uint32_t xThilde[32];
	uint32_t block;
	uint32_t shifter;
//	uint32_t One[32] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1};
	uint32_t One[32] = {1,0};
	uint8_t i;
	uint32_t t;
	montMulOpt(x,r2,n,n_prime,xThilde,size);
	for (i=0; i<size; i++){
		aCapital[i] = r[i];
	}
	for(t = el; t > 0; t--){
		montMulOpt(aCapital,aCapital,n,n_prime,aCapital,size);
		block = t/size;
		shifter = t%size -1;
		if (((e[block] >> shifter) & 1) == 1){
			montMulOpt(aCapital,xThilde,n,n_prime,aCapital,size);
		}
	}
	montMulOpt(One,aCapital,n,n_prime,aCapital,size);
}




