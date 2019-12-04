/*
 * montgomeryOpt.h
 *
 */

#ifndef MONTOGOMERYOPT_H_
#define MONTOGOMERYOPT_H_

#include <stdint.h>
#include <inttypes.h>
#include "common.h"

// Calculates res = a * b * r^(-1) mod n.
// a, b, n, n_prime represent operands of size elements
// res has (size+1) elements
void montMulOpt(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *n_prime, uint32_t *res, uint32_t size);

#endif /* MONTOGOMERYOPT_H_ */
