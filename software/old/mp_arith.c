/*
 * mp_arith.c
 *
 */

#include <stdint.h>

// Calculates res = a + b.
// a and b represent large integers stored in uint32_t arrays
// a and b are arrays of size elements, res has size+1 elements
void mp_add(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{
	uint64_t temp;
	uint8_t i;
	uint32_t carry = 0;
	for (i=0; i < size; i++) {
		temp = (uint64_t) a[i] + b[i] + carry;
		res[i] = (uint32_t) temp; //Cast to 32 bit
		carry = (uint32_t) (temp >> 32);
	}
	res[size] = carry;
}

// Calculates res = a - b.
// a and b represent large integers stored in uint32_t arrays
// a, b and res are arrays of size elements
void mp_sub(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{
	uint32_t temp;
	uint8_t i;
	uint32_t negative_carry = 0;
	for (i=0; i < size; i++) {
		temp = a[i] - b[i] - negative_carry;
		res[i] = (uint32_t) temp; //Cast to 32 bit
		if (a[i] > b[i] + negative_carry) {
			negative_carry = 0;
		} else {
			negative_carry = 1;
		}
	}
}

// Calculates res = (a + b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_add(uint32_t *a, uint32_t *b, uint32_t *N, uint32_t *res, uint32_t size)
{
    int bigger = 0;
    uint32_t temp[size+1];
    uint32_t done = 0;
    mp_add(a, b, temp,size);
    if (temp[size] == 0){
        while(done != size-1 && bigger == 0 ){
            if(temp[(size-done)] >= N[(size-done)] ){
                bigger = 1;
            }
            done++;
        }
    }
    else {
    	bigger = 1;
    }
    if (bigger > 0){
    	uint32_t temp_N[size+1];
        for (uint32_t index =0; index <size ; index++){
           temp_N[index] = N[index];
        }
        temp_N[size] = 0x00000000;
        mp_sub(temp,temp_N, res,size+1);
    }
    else {
        for (uint32_t index =0; index <=size ; index++){
           res[index] = temp[index];
        }
    }

}

// Calculates res = (a - b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_sub(uint32_t *a, uint32_t *b, uint32_t *N, uint32_t *res, uint32_t size)
{
	uint32_t temp;
	uint8_t i;
	uint32_t negative_carry = 0;
	for (i=0; i < size; i++) {
		temp = a[i] - b[i] - negative_carry;
		res[i] = (uint32_t) temp; //Cast to 32 bit
		if (a[i] > b[i] + negative_carry) {
			negative_carry = 0;
		} else {
			negative_carry = 1;
		}
	}
	if (negative_carry==1) { //b is greater than a
		mp_add(res, N, res, size);
	}

}

