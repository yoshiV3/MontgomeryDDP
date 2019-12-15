/*
 * montgomeryOpt.h
 *
 */

#ifndef ASM_MONTOGOMERYOPT_H_
#define ASM_MONTOGOMERYOPT_H_

#include <stdint.h>

// Calculates res = a * b * r^(-1) mod n.
// a, b, n, n_prime represent operands of size elements
// res has (size+1) elements
void reduction(uint32_t *n, uint32_t *nprime, uint32_t *t, uint32_t i, uint32_t size);

void multiplication(uint32_t *a, uint32_t *b, uint32_t *t, uint32_t i, uint32_t size);

void clear(uint32_t *, uint32_t size);

void copy(uint32_t * t, uint32_t * res, uint32_t size);

#endif /* ASM_MONTOGOMERYOPT_H_ */
